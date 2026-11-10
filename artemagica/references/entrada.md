# Entrada (a referência) e geração de assets

Lido pela conversa principal. Duas portas de entrada; as duas terminam numa **referência aprovada** em `referencia/aprovada.png`, base do plano.

## Porta A — imagem pronta

O usuário manda uma imagem (um KV, uma arte de referência, um layout que ele gostou).
1. Crie a pasta do job e copie a imagem para `referencia/`. Se vier em JPG ou WEBP, converta **uma vez** para PNG: essa é a `aprovada.png`.
2. Confira, para pôr no plano:
   - o tamanho real em px e a proporção, e se batem com o formato final;
   - o texto, letra por letra;
   - se há logo ou marca.
   Texto errado ou logo diferente do oficial **não** pedem nova geração da arte inteira: o plano resolve isso nos assets e na montagem.
3. Formato final: o que o usuário disser. Se ele não disser, use a proporção da referência no tamanho do formato da campanha mais parecido (`kv` 3600×2400, `stories` 1080×1920) e conte na entrega.

## Porta B — briefing

O usuário dá o briefing, as referências e as informações. Leia também `cerebro/prompts.md`.
1. Escreva `ideias.md` com **4 ideias criativas diferentes**, não 4 variações da mesma cena:
   - cada uma começa por uma ideia visual em uma frase, que funcionaria até sem texto;
   - fuja da fórmula "foto bonita + título no espaço vazio": em pelo menos 2, o título faz parte da cena;
   - fundo com profundidade, nunca cor chapada genérica;
   - o título da campanha é o 1º ou o 2º elemento em destaque.
2. **Prompt:** a ideia e a cena em 3 a 5 frases vívidas; depois um bloco curto de regras, com no máximo ~8 proibições. Traga os textos exatos, o formato e a paleta da marca. Proíba por padrão pinceladas, sublinhados, aspas e rabiscos decorativos (no máximo um, de propósito).
3. **Pare** para o usuário aprovar as ideias.
4. Gere as 4 com o gerador do Codex e olhe cada uma ampliada antes de mostrar. Mostre lado a lado, com a ideia de cada uma e os defeitos apontados com honestidade.
5. O usuário escolhe, pede ajuste (só o que ele pediu, a partir da opção limpa) ou pede nova rodada.
6. A escolhida vira `referencia/aprovada.png`, e daí segue o plano.

## Gerar um elemento em alta

Antes de gerar um elemento difícil, pesquise e pergunte ao instrutor de Photoshop qual o melhor prompt e referência (`SKILL.md`, "Pesquise e pergunte antes de fazer").

- Gere o elemento **sozinho, ocupando o quadro inteiro**: ele sai com muito mais pixels do que tinha dentro da arte. Mande o recorte da referência como guia ("o mesmo elemento, mesma pose, luz e ângulo, isolado, fundo liso, alta resolução").
- **Fundo novo:** gere a cena vazia, na mesma luz, cor e perspectiva, sem os elementos na frente. Ele vira a camada de baixo inteira; nada fica com buraco.
- **Lettering do título:** gere a palavra sozinha, no mesmo estilo e material. Grafia letra por letra.
- Toda tentativa sai do recorte da referência + o plano, nunca da tentativa anterior. Tentativas em `assets/tentativas/`; aprovados, recortados, em `assets/aprovados/`.
- Produto real e rótulo nunca são gerados: peça a foto ou o arquivo oficial ao usuário. Preço, data, condição e legal viram texto digitável.
- Olhe a 100%, ao lado do recorte da referência: grafia, mãos, nitidez, resolução real, se lembra o elemento original. Ruim? Refaça antes de mostrar.
- Ainda pequeno? Amplie no Photoshop (Preservar Detalhes) só se continuar nítido a 100%: fundo desfocado amplia bem; rosto, mão, letra e logo, quase nunca. Ainda não chega? Mostre o melhor a 100% ao usuário e diga o maior tamanho em que fica bom; não contrate outro serviço.

Toda geração vai para `revisao/geracoes.md`: arquivo, gerador, prompt, referências, tamanho real e custo.
