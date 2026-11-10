# Entrada (a referência) e geração de assets

Lido pela conversa principal.

## A referência

O usuário manda uma imagem (um KV, uma arte de referência, um layout que ele gostou).
1. Crie a pasta do job e copie a imagem para `referencia/`. Se vier em JPG ou WEBP, converta **uma vez** para PNG: essa é a `aprovada.png`.
2. Confira, para pôr no plano:
   - o tamanho real em px e a proporção, e se batem com o formato final;
   - o texto, letra por letra;
   - se há logo ou marca.
   Texto errado ou logo diferente do oficial **não** pedem nova geração da arte inteira: o plano resolve isso nos assets e na montagem. A referência dá a direção; os defeitos dela não precisam ser copiados.
3. Formato final: o que o usuário disser. Se ele não disser, use a proporção da referência no tamanho mais parecido, com a resolução da seção "Resolução" da `SKILL.md`, e conte na entrega.

**Só briefing, sem imagem?** Esta skill não cria a arte: gere a imagem antes (no gerador do Codex, por exemplo) e volte com ela.

## Gerar um elemento

Não sabe qual prompt ou referência usar para um elemento difícil? Pergunte ao instrutor de Photoshop antes de gerar.

- Gere o elemento **sozinho, ocupando o quadro inteiro**: ele sai com muito mais pixels do que tinha dentro da arte. Mande o recorte da referência como guia ("o mesmo elemento, mesma pose, luz e ângulo, isolado, fundo liso, alta resolução").
- Tudo segue o **mapa da cena** do plano: mesma direção de luz, temperatura, perspectiva e altura de câmera. Diga isso no prompt.
- **Fundo novo:** gere a cena vazia, na mesma luz, cor e perspectiva, sem os elementos na frente. Ele vira a camada de baixo inteira; nada fica com buraco. Deixe sobra nas bordas para o formato de teste.
- **Lettering do título:** gere a palavra sozinha, no mesmo estilo e material. Grafia letra por letra.
- Toda tentativa sai do recorte da referência + o plano, nunca da tentativa anterior. Tentativas em `assets/tentativas/`; aprovados, recortados, em `assets/aprovados/`.
- Produto real, rótulo e logo nunca são gerados: use o arquivo oficial ou peça ao usuário. Preço, data, condição e legal viram texto digitável.
- Olhe a 100%, ao lado do recorte da referência: grafia, mãos, nitidez, resolução real, se lembra o elemento original. Ruim? Refaça.
- Ainda pequeno para o tamanho que ocupa? Amplie (Preservar Detalhes ou ampliação por IA) só se continuar nítido a 100%: fundo desfocado amplia bem; rosto, mão, letra e logo, quase nunca. Não amplie só para bater número. Ainda não chega? Mostre o melhor a 100% ao usuário e diga o maior tamanho em que fica bom; não contrate outro serviço.
- **Recorte limpo:** cabelo, pelo, vidro e reflexo costumam carregar a cor do fundo antigo. Gere sobre fundo liso de cor parecida com a da cena, ou limpe a borda (descontaminar cores, máscara refinada) e confira sobre o fundo novo.

Toda geração vai para `revisao/geracoes.md`: arquivo, gerador, prompt, referências, tamanho real e custo.
