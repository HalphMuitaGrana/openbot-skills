---
name: revisao-da-semana
description: "Fecha a semana e escolhe até 3 prioridades para a próxima. Use para revisão semanal, planejar a semana, ver pendências ou entender como andam os projetos. Não use para o plano detalhado de um projeto só."
example-prompt: "Fecha minha semana e me diz as 3 prioridades da próxima."
---

# Revisão da semana

## Quando usar

- Fechar a semana ou planejar a próxima.
- Revisar prioridades e pendências.
- Entender como andam os projetos.
- Não use para o plano detalhado de um projeto só.

## O que precisa

1. **Conversas recentes**, com `openbot.history_search`.
2. **Agenda, tarefas e e-mail**, quando conectados. Procure com `tool_search` no grupo `openbot`.
3. **Notas dos projetos.** Diga o que não conseguiu olhar.

## Passos

1. Junte o que existe.
2. Liste o que foi concluído, só com prova. Em andamento não conta como pronto.
3. Liste o que travou, com o motivo e de quem depende.
4. Liste as promessas abertas: o que o dono prometeu e o que prometeram a ele.
5. Veja compromissos e prazos dos próximos 7 dias.
6. Proponha **no máximo 3 prioridades**, cada uma com o resultado esperado e o primeiro passo.
7. Diga o que deixar de fora. Priorizar é escolher o que não fazer agora.

## Resultado

```text
Semana de <data> a <data>

Feito: ...
Travado: ... (depende de ...)
Promessas: ...
Próximos 7 dias: ...

Prioridades:
1. <resultado> | primeiro passo: ...
2. ...
3. ...

Fica para depois: ...
```

Na voz, diga só as três prioridades e o que está travado.

## Aprovações e quando parar

- Não mude agenda nem tarefas sem o ok do dono.
- Item adiado três vezes vira uma pergunta: fazer, delegar ou abandonar?
- Sem prova de progresso, escreva "não confirmado".

## Rotinas

Para repetir toda semana, use `rotinas-sem-gasto` e combine dia e hora. Se não houver nada novo, chame `routine_no_update`.

## Erros comuns

- Entregar um relatório do passado sem decidir a próxima semana.
- Contar como pronto o que está em andamento.
- Propor mais de 3 prioridades.
- Esconder o que não conseguiu consultar.
