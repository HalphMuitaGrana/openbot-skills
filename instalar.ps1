param(
  [Parameter(Mandatory = $true)][string]$AgentWorkspace,
  [string[]]$Skill = @(),
  [switch]$Update
)

# Copies skills into an agent workspace, in the two folders that OpenBot providers read.
# Existing skills are kept unless -Update is passed.

$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot 'skills'

if (-not (Test-Path -LiteralPath $AgentWorkspace -PathType Container)) {
  Write-Host "Pasta do agente nao encontrada: $AgentWorkspace"
  exit 1
}

$available = @(Get-ChildItem -LiteralPath $root -Recurse -Filter 'SKILL.md' | ForEach-Object { $_.Directory })
$selected = if ($Skill.Count -gt 0) { @($available | Where-Object { $Skill -contains $_.Name }) } else { $available }
$missing = @($Skill | Where-Object { ($available | ForEach-Object Name) -notcontains $_ })
if ($missing.Count -gt 0) {
  Write-Host ('Skill nao encontrada: ' + ($missing -join ', '))
  exit 1
}

foreach ($folderName in '.agents', '.claude') {
  $target = Join-Path (Join-Path $AgentWorkspace $folderName) 'skills'
  New-Item -ItemType Directory -Force -Path $target | Out-Null
  foreach ($source in $selected) {
    $destination = Join-Path $target $source.Name
    if (Test-Path -LiteralPath $destination) {
      if (-not $Update) {
        Write-Host "Ja existe, mantida: $folderName\skills\$($source.Name)"
        continue
      }
      $resolved = (Resolve-Path -LiteralPath $destination).Path
      if (-not $resolved.StartsWith((Resolve-Path -LiteralPath $target).Path + '\')) { throw 'Destino fora da pasta de skills' }
      Remove-Item -LiteralPath $resolved -Recurse -Force
    }
    Copy-Item -LiteralPath $source.FullName -Destination $destination -Recurse
    Write-Host "Instalada: $folderName\skills\$($source.Name)"
  }
}

Write-Host 'Pronto. Abra uma conversa nova com o agente para ele carregar as skills.'
