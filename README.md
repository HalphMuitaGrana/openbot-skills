# openbot-skills

Skills de assistente para o **OpenBot Pessoal**, escritas do zero em português, no formato das skills do catálogo do OpenBot e
para as ferramentas dele. As referências que inspiraram cada uma estão em [CREDITOS.md](CREDITOS.md).

## O que tem (8 skills)

| Categoria | Skill | Para quê |
| --- | --- | --- |
| rotinas | `rotinas-sem-gasto` | vigiar e lembrar gastando modelo só quando há novidade |
| mensagens | `revisar-antes-de-enviar` | deixar a resposta pronta e só enviar com o sim do dono |
| mensagens | `email-e-mensagens` | dizer o que precisa do dono, em ordem de importância |
| escrita | `escrever-sem-cara-de-ia` | textos diretos, naturais e sem frases feitas |
| app | `onde-fica-cada-coisa` | achar opções, resolver problemas e responder "o que você faz?" |
| organizacao | `revisao-da-semana` | fechar a semana e escolher até 3 prioridades |
| organizacao | `reuniao-vira-tarefa` | transformar reunião em decisões e tarefas |
| organizacao | `documento-vira-tarefa` | transformar documento em ações, prazos e riscos |

## Como instalar

No OpenBot, cole o link deste repositório na opção de adicionar skill pelo GitHub:

```text
https://github.com/HalphMuitaGrana/openbot-skills
```

Também dá para instalar por uma cópia local. Com o repositório clonado, rode no PowerShell, trocando a pasta do agente:

```powershell
.\instalar.ps1 -AgentWorkspace "<pasta do agente>" -Skill rotinas-sem-gasto,revisar-antes-de-enviar
```

Sem `-Skill`, instala as 8. O script copia para `.agents/skills` e `.claude/skills`, as pastas que os motores do OpenBot leem. Skill
que já existe não é sobrescrita; para atualizar, use `-Update`. Depois, abra uma conversa nova com o agente.

Instale só as que aquele bot vai usar. Antes, confira se ele já tem uma skill com o mesmo trabalho.

## Regras deste repositório

- Uma pasta por skill, com o `name` igual ao nome da pasta.
- `description` de até 300 caracteres, dizendo o que faz, quando usar e quando não usar. Acima disso, alguns motores cortam o texto.
- Corpo no formato do catálogo do OpenBot: Quando usar, O que precisa, Passos, Resultado, Aprovações e quando parar, Rotinas (se
  houver) e Erros comuns.
- Nada de senha, token, número de telefone ou dado pessoal.
- Referência de terceiros entra como ideia, escrita com as nossas palavras. Se um trecho for aproveitado, a licença dele precisa
  permitir e o aviso fica em `CREDITOS.md`.
