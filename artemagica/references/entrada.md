# Entrada (o molde)

Lido pela conversa principal. Duas portas de entrada; as duas terminam num **molde aprovado** em `molde/aprovado.png`.

## Porta A — imagem pronta

O usuário manda uma imagem (um KV, uma arte de referência, um layout que ele gostou).
1. Crie a pasta do job e copie a imagem para `referencia/`. Se vier em JPG ou WEBP, converta **uma vez** para PNG.
2. Confira e diga ao usuário, em poucas linhas:
   - o tamanho real em px e a proporção;
   - se a proporção bate com o formato final;
   - o que tem de texto (grafia, letra por letra);
   - se há logo ou marca.
   Texto errado ou logo diferente do oficial **não** pedem nova geração agora: anote, e isso se resolve nos assets e na montagem.
3. Pergunte o formato final, se não for óbvio (`kv` 3600×2400, `stories` 1080×1920 ou outro).
4. Com o "ok" do usuário, a imagem vira `molde/aprovado.png`. **APROVAÇÃO do molde.**

## Porta B — briefing

O usuário dá o briefing , as referências e as informações. Leia também `cerebro/prompts.md`.
1. Escreva `plano.md` com **4 ideias criativas diferentes**, não 4 variações da mesma cena:
   - cada uma começa por uma ideia visual em uma frase, que funcionaria até sem texto;
   - fuja da fórmula "foto bonita + título no espaço vazio": em pelo menos 2, o título faz parte da cena;
   - fundo com profundidade, nunca cor chapada genérica;
   - o título da campanha é o 1º ou o 2º elemento em destaque.
2. **Prompt:** a ideia e a cena em 3 a 5 frases vívidas; depois um bloco curto de regras, com no máximo ~8 proibições. Traga os textos exatos, o formato e a paleta da marca. Proíba por padrão pinceladas, sublinhados, aspas e rabiscos decorativos (no máximo um, de propósito).
3. **Pare** para o usuário aprovar o plano.
4. Gere as 4 com o gerador do Codex e olhe cada uma ampliada antes de mostrar. Mostre lado a lado, com a ideia de cada uma e os defeitos apontados com honestidade.
5. O usuário escolhe, pede ajuste (só o que ele pediu, a partir da opção limpa) ou pede nova rodada.
6. A escolhida vira `molde/aprovado.png`. **APROVAÇÃO do molde.**

Toda geração vai para `revisao/geracoes.md`: arquivo, gerador, prompt, referências enviadas e tamanho real.
