param(
  [Parameter(Mandatory = $true)][string]$AgentId,
  [Parameter(Mandatory = $true)][string]$RoutineId,
  [Parameter(Mandatory = $true)][string]$Check,
  [Parameter(Mandatory = $true)][string]$StateFile,
  [string]$AutomationDir = (Join-Path $env:APPDATA 'OpenBot\automation'),
  [switch]$DryRun
)

# Runs a small check without any model and starts an OpenBot routine only when it finds something new.
# The check prints one JSON line: {"acordar":true,"ids":["a"],"contexto":{}} or {"acordar":false}.
# Never prints the automation token.

$ErrorActionPreference = 'Stop'
$MaxDelivered = 2000
$MaxAttempts = 3
$FailuresBeforeWarning = 3
$MaxBodyBytes = 30000

function Read-State {
  $state = @{ falhas = 0; ultimoAvisoFalha = ''; entregues = @(); tentativas = @{}; desistiu = @() }
  if (-not (Test-Path -LiteralPath $StateFile)) { return $state }
  try {
    $saved = Get-Content -LiteralPath $StateFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $state.falhas = [int]$saved.falhas
    $state.ultimoAvisoFalha = [string]$saved.ultimoAvisoFalha
    $state.entregues = @($saved.entregues | Where-Object { $_ })
    $state.desistiu = @($saved.desistiu | Where-Object { $_ })
    if ($saved.tentativas) {
      foreach ($property in $saved.tentativas.PSObject.Properties) { $state.tentativas[$property.Name] = [int]$property.Value }
    }
  } catch {
    Write-Output 'estado ilegivel: comecando de novo'
  }
  return $state
}

function Save-State($state) {
  $temporary = "$StateFile.tmp"
  $json = $state | ConvertTo-Json -Depth 5 -Compress
  [System.IO.File]::WriteAllText($temporary, $json, (New-Object System.Text.UTF8Encoding($false)))
  Move-Item -LiteralPath $temporary -Destination $StateFile -Force
}

function Invoke-Check {
  $global:LASTEXITCODE = 0
  $lines = @(& $Check 2>$null)
  if ($LASTEXITCODE -ne 0) { throw 'a conferencia terminou com erro' }
  $last = $lines | Where-Object { "$_".Trim() } | Select-Object -Last 1
  if (-not $last) { throw 'a conferencia nao imprimiu resultado' }
  $result = "$last" | ConvertFrom-Json
  if ($null -eq $result.acordar) { throw 'resultado sem o campo acordar' }
  return $result
}

function Send-Wake($data) {
  $payload = $data | ConvertTo-Json -Depth 8 -Compress
  $body = @{ payload = $payload } | ConvertTo-Json -Compress
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
  if ($bytes.Length -gt $MaxBodyBytes) {
    Write-Host 'contexto grande demais: envie menos dados'
    return $false
  }
  if ($DryRun) {
    Write-Host "[simulacao] acordaria a rotina com: $payload"
    return $true
  }
  try {
    $url = (Get-Content -LiteralPath (Join-Path $AutomationDir 'url') -Raw).Trim()
    $token = (Get-Content -LiteralPath (Join-Path $AutomationDir 'token') -Raw).Trim()
    $route = "$url/v1/agents/$AgentId/routines/$RoutineId/run"
    $null = Invoke-RestMethod -Method Post -Uri $route -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json; charset=utf-8' -Body $bytes
    Write-Host 'rotina colocada na fila'
    return $true
  } catch {
    Write-Host 'nao foi possivel acordar a rotina: confira se o OpenBot esta aberto e com Local scripts ligado'
    return $false
  }
}

$state = Read-State

try {
  $result = Invoke-Check
} catch {
  $state.falhas = [int]$state.falhas + 1
  $today = (Get-Date).ToString('yyyy-MM-dd')
  if ($state.falhas -ge $FailuresBeforeWarning -and $state.ultimoAvisoFalha -ne $today) {
    if (Send-Wake @{ problema = "a conferencia falhou $($state.falhas) vezes seguidas" }) { $state.ultimoAvisoFalha = $today }
  } else {
    Write-Output "conferencia falhou ($($state.falhas)): sem aviso por enquanto"
  }
  Save-State $state
  exit 0
}

$state.falhas = 0
$state.ultimoAvisoFalha = ''

$known = @($state.entregues) + @($state.desistiu)
$new = @(@($result.ids) | Where-Object { $_ } | ForEach-Object { "$_" } | Where-Object { $known -notcontains $_ } | Select-Object -Unique)
$hasIds = $null -ne $result.PSObject.Properties['ids']
$wantsWake = [bool]$result.acordar -and ((-not $hasIds) -or $new.Count -gt 0)
$gaveUp = @($state.desistiu)

if (-not $wantsWake -and $gaveUp.Count -eq 0) {
  Write-Output 'nada novo: nenhum modelo acordado'
  Save-State $state
  exit 0
}

$data = @{}
if ($wantsWake) {
  $data.ids = $new
  if ($result.contexto) { $data.contexto = $result.contexto }
}
if ($gaveUp.Count -gt 0) { $data.naoEntregues = $gaveUp }

if (Send-Wake $data) {
  $state.entregues = @(@($state.entregues) + $new + $gaveUp | Select-Object -Last $MaxDelivered)
  $state.desistiu = @()
  foreach ($id in $new) { $state.tentativas.Remove($id) }
} else {
  foreach ($id in $new) {
    $attempts = 1
    if ($state.tentativas.ContainsKey($id)) { $attempts = [int]$state.tentativas[$id] + 1 }
    if ($attempts -ge $MaxAttempts) {
      $state.desistiu = @(@($state.desistiu) + $id)
      $state.tentativas.Remove($id)
    } else {
      $state.tentativas[$id] = $attempts
    }
  }
}

Save-State $state
exit 0
