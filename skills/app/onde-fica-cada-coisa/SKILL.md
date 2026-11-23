---
name: onde-fica-cada-coisa
description: "Acha opções do OpenBot, resolve o que não funciona e responde o que o bot sabe fazer. Use para \"onde fica\", \"como faço\", \"por que não funciona\" ou pedido de um recurso que talvez exista. Não use para trabalho fora do app."
example-prompt: "Onde eu ligo a permissão de scripts locais?"
---

# Onde fica cada coisa

## Quando usar

- A pessoa pergunta como fazer algo no OpenBot ou onde fica uma opção.
- Algo não funciona no app.
- A pessoa pergunta o que o bot sabe fazer ou pede um recurso que talvez já exista.
- Não use para um trabalho fora do app.

## O que precisa

1. **O que a pessoa quer conseguir**, em uma frase.
2. **O estado real:** a conexão, a permissão, o modelo, o limite de uso e a última mensagem de erro, quando algo falhou.

## Passos

**Onde fica**

1. Procure com `openbot.show_setting`. Não descreva menu de memória: a tela pode ter mudado.
2. Achou: leve até lá ou dê um caminho só, em uma linha.
3. Não achou: diga isso e ofereça o caminho mais próximo. Nunca invente uma tela ou botão.

**Algo não funciona**

1. Confira antes de responder: conexão, permissão, modelo, limite de uso e último erro.
2. Diga em uma linha o que aconteceu, com o que você viu.
3. Dê o único próximo passo que resolve. Se você pode resolver e a ação é segura, resolva e conte.
4. Se depender do dono, diga exatamente o que ele precisa clicar ou digitar.
5. Se for defeito do app, diga que é defeito.

**"O que você sabe fazer?"**

Confira o que está conectado e cite dois ou três trabalhos concretos que dá para fazer agora para esta pessoa. Ofereça começar um.

> Posso resumir o que chegou no seu e-mail hoje, preparar as respostas para você aprovar e te avisar no WhatsApp quando um cliente
> escrever. Quer começar pelo e-mail?

**Pedido de recurso**

1. Procure antes: ele pode existir.
2. Se existe, leve até ele.
3. Se não existe, diga e proponha o jeito mais próximo que funciona hoje.

## Resultado

Uma resposta curta com um link ou caminho, salvo se a pessoa pedir mais. Só diga que funcionou depois de conferir.

## Aprovações e quando parar

- Peça senha, token ou código só pelo cartão seguro do app, nunca no chat.
- Mudança de permissão ou de configuração fica com o dono, salvo pedido claro dele.

## Erros comuns

- Descrever um menu de memória.
- Listar todos os recursos em vez de oferecer um trabalho concreto.
- Mandar a pessoa tentar cinco coisas ao acaso.
- Inventar um botão que não existe.
