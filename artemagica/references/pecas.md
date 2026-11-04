# Peças: o que separar e o que gerar em alta

Lido pela conversa principal depois do molde aprovado.

## Separar por objeto inteiro

A unidade é **o que se move junto**, não cada coisa que se vê:
- selo + pallet + presentes formam um expositor; dividir cada caixa destrói a sombra e esconde a base;
- carrinho + compras dividem a mesma malha e a mesma perspectiva;
- personagem sozinho, mas o que encosta nele (mão no guidão) precisa de um reparo próprio;
- fundo e piso com a perspectiva e os reflexos deles.

Escreva `pecas.md` com uma linha por elemento:
- posição no molde (px);
- tamanho no formato final (px);
- sugestão: `do molde` (vem dos pixels do molde) ou `gerar em alta`, com o porquê.

Preço, data, condição e legal nunca são gerados: viram texto digitável. Logo: regra na `SKILL.md`.

## Quando gerar em alta

Só quando o molde não dá conta:
- **Resolução:** o elemento precisa de mais pixels no formato final do que o molde tem. Exemplos: rosto, mão, objeto, lettering. Produto real e rótulo nunca são gerados: peça a foto ou o arquivo oficial ao usuário.
- **Teste do designer:** o elemento esconde algo que o designer vai querer mover, e é preciso o objeto inteiro ou o fundo atrás dele.

Do resto, use os pixels do molde.

## Resolução, só com o Codex e o Photoshop

O gerador do Codex entrega um tamanho limitado: meça sempre no arquivo salvo. Tente nesta ordem:
1. **Gere a peça sozinha, ocupando o quadro inteiro.** Ela sai com muito mais pixels do que tinha dentro da arte completa, e costuma bastar.
2. **Peça grande demais:** gere as partes que precisam de detalhe (rosto, mãos) e junte no Photoshop, com máscara suave.
3. **Amplie no Photoshop** (Tamanho da imagem > Preservar Detalhes). Em fundo desfocado, sem medo. Em rosto, mão, lettering e logo, só se continuar nítido a 100%.
4. **Ainda não chega?** Mostre o melhor resultado ao usuário a 100% e diga o maior tamanho em que ele fica bom. Quem decide é ele; não contrate outro serviço.

## Como mostrar e gerar

1. Mostre ao usuário a lista inteira numa mensagem, com a sugestão de cada item. Ele aprova ou muda.
2. Depois, **um asset por vez**:
   - gere com o recorte do molde como referência ("o mesmo elemento, mesma pose, luz e ângulo, isolado, alta resolução");
   - confira a 100% antes de mostrar: mãos, grafia, nitidez, resolução real;
   - mostre ao lado do recorte do molde e pergunte: aprova ou refaço?
3. Toda tentativa sai do recorte do molde + o pedido do usuário, nunca da tentativa anterior. Tentativas ficam em `assets/tentativas/`; os aprovados, recortados, em `assets/aprovados/`.
4. Leia `cerebro/prompts.md` antes de escrever. O que funcionou ou falhou fica em `revisao/geracoes.md`; vai para o cérebro só na aula, com o "ok" do usuário.

**Asset aprovado diferente do molde** (outro rosto, outra pose): gere uma vez o molde com ele, usando o molde e os assets como referência. Ele vira o próximo `molde/alvo-vNN.png` e passa pela aprovação do usuário. A régua e o olheiro medem cada pedaço, inclusive o interior do asset, contra esse alvo. Sem isso, a comparação fica injusta.

Toda geração vai para `revisao/geracoes.md`: arquivo, gerador, prompt, referências, tamanho real e custo.
