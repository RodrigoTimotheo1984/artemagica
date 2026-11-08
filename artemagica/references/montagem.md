# Montar, conferir, testar e entregar

Lido pela conversa principal e pelo montador. **Alvo:** o vigente (`SKILL.md`, "Aprovações"). São dicas: o que deu certo até hoje. Achou um caminho melhor, use-o e conte na aula. A cada camada que entrar, exporte e olhe: não deixe para descobrir o problema só no fim.

## Montar fatiando o molde (o que mais deu certo)

Copiar os pixels do molde chega muito mais perto do que remontar cada coisa. Num teste real, isso levou um elemento de 58% para 96%.

1. **Documento** no tamanho do formato final, no perfil de cor do destino combinado (sem combinado: sRGB). Converta o perfil de tudo o que entrar. A régua sempre mede em sRGB, seja qual for o perfil do arquivo.
2. **Fundo:**
   - o molde inteiro embaixo;
   - por cima, reconstrua **só o que fica escondido** atrás dos elementos (preenchimento sensível ao conteúdo, generativo ou um fundo gerado limpo), com máscara;
   - não troque o fundo inteiro por um gerado: ele muda detalhes, alinhamento e contraste.
3. **Elementos:**
   - cada um é uma cópia do molde do **tamanho da tela inteira**, no mesmo lugar, com máscara no contorno do objeto (incluindo a sombra e o reflexo dele). Nunca reposicione pelos limites do recorte;
   - asset gerado em alta entra no mesmo lugar, alinhado por cima;
   - depois, cada elemento vira **objeto inteligente**.
4. **Texto, duas composições de camadas:**
   - **"Arte"** (a que abre): o lettering do molde, com máscara nas letras, o brilho e a sombra junto, e o fundo reparado embaixo;
   - **"Editar texto"**: fonte instalada parecida (prova de fontes, escolha no olho). Antes de fechar a largura de cada linha:
     - meça **letra por letra** (às vezes só a primeira letra é maior);
     - reserve o espaço entre as palavras;
   - material, volume e sombra como **estilo de camada na própria camada de texto**, **nunca** cópias soltas que não acompanham a troca de palavra (cópias de texto dentro de um objeto inteligente também não acompanham);
   - brilho pontual (um reflexo pequeno numa letra) é uma camada própria por cima, no mesmo grupo da palavra, para mover junto. Trocou a palavra, confira se o brilho ainda cai numa letra.
5. **Efeitos de cena** (fumaça, névoa, brilho, cor geral): cada um numa camada própria, nomeada, com máscara.
6. **Mudanças do usuário:** confira `mudancas.md` antes de cada volta.

Use as receitas do [cardápio](ferramentas/cardapio.md) e as técnicas do cérebro. Não sabe fazer? Pergunte ao técnico.

## Organização do PSD (para o designer)

De baixo para cima, com nomes em português e até ~30 itens no primeiro nível (menos é melhor, se tudo continuar fácil de achar):
```
Fundo | molde + reparo escondido + ajustes de cor
Pessoas e personagens | um objeto inteligente por pessoa
Elementos | produtos e objetos
Efeitos | fumaça, névoa, brilhos
Textos | um grupo "Arte" (lettering do molde) e um grupo "Editar texto"
Selo e assinatura | oficial
```
As composições de camadas ("Arte" e "Editar texto") ficam no painel Composições de camadas e valem para o documento inteiro: cada uma liga um dos dois grupos de texto e desliga o outro.
Antes de entregar, apague as provas, os grupos de tentativa e as camadas temporárias. Oculto só o que pertence à outra composição.

## Voltas

Monte → exporte a prova → **meça** com a régua → **olhe** a prova inteira e cada pedaço, ampliado, ao lado do alvo (os abaixo de 95 primeiro, mas todos) → pense no que mudar → corrija → repita.

Rode a partir da **pasta do job**, com o Python que respondeu na conferência inicial da `SKILL.md` (troque `<alvo vigente>` por `molde/aprovado.png` ou pelo `molde/alvo-vNN.png` mais recente):
```powershell
New-Item -ItemType Directory -Force revisao/medidas | Out-Null
& "$env:USERPROFILE\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" "<skill>/references/ferramentas/medir-semelhanca.py" --molde <alvo vigente> --montagem revisao/provas/vNN.png --pecas revisao/medidas/pecas.json --folhas revisao/medidas/vNN --saida revisao/medidas/vNN.txt
```
- `pecas.json` tem as caixas de cada pedaço, em px do alvo: personagens, produtos, selo, **cada linha de texto**, piso e fundo. Pedaço do texto editável leva meta 90: `"chamada": {"caixa": [810,58,1490,200], "meta": 90}`.
- A caixa de uma linha de texto pega também o fundo entre as letras: a nota dela não prova sozinha o desenho das letras. Confira as letras no olho, ampliado.
- `INCONCLUSIVO` na saída (perfil de cor que não converteu, proporção diferente, caixa fora da imagem) não vale como nota: resolva antes.
- A régua não vê tudo. Confira também, no olho e ampliado, os itens de `cerebro/olho.md`: brilho pequeno, reflexo, sombra de contato, espaço entre palavras, fumaça e névoa.

## Conferir antes de mostrar

1. **Reabra o PSD salvo** com `verificar-psd.jsx`. Ele:
   - recusa rodar se o PSD já estiver aberto (feche você, ou use uma cópia);
   - conta os itens do primeiro nível e aponta sobras;
   - acha máscara vazia ou toda branca;
   - aplica cada composição e exporta uma prova de cada.

   Abra as provas e olhe. Máscara toda branca pode ser de propósito: confira no olho.
2. **Teste do designer**, numa cópia, sem salvar. Faça cada ação como um designer faria à mão e anote quantos passos levou e o que aconteceu:
   - troque uma palavra que tenha volume por outra **de tamanho diferente**; confira volume, sombra e brilho;
   - troque o preço;
   - mude a posição de um texto;
   - mova um personagem e olhe o fundo atrás dele, as bordas e onde ele encostava.

   Exporte a prova de cada ação para `revisao/provas/da-<acao>.png`.
3. **Teste de formato**, numa cópia: primeiro mude o tamanho da tela para o novo formato, depois mova e escale as camadas, sem gerar nada. Exporte para `revisao/provas/formato-<nome>.png` e olhe a 100%. Buraco no fundo, borda vazia ou elemento grudado no fundo é falha de construção.
4. **Olheiro novo** ([olheiro.md](olheiro.md)).
5. **Comparativo** `exportacoes/comparativo-vNN.png`, com 3 quadros no mesmo tamanho: alvo | "Arte" | "Editar texto". **Abra o comparativo inteiro** e confira a cor de cada quadro antes de enviar.

## Entrega

Mostre ao usuário:
- o comparativo;
- o caminho do PSD e da pasta dos assets principais separados (`assets/aprovados/` e recortes);
- a tabela da entrega (abaixo);
- o resultado dos testes do designer e de formato;
- uma nota curta: o que ficou aproximado, as mudanças dele e o tempo.

**Tabela da entrega**, uma linha por pedaço em cada composição:
```
| composição | pedaço | alvo usado | régua | olho | piso | bloqueios |
| Arte | produto | alvo-v01.png | 96,1 | 95 | 95 | nenhum |
| Editar texto | chamada | alvo-v01.png | 88,1 | 91 | 90 | nenhum |
```
Grafia e espaço entre palavras entram na coluna de bloqueios. Abaixo do piso só passa se o usuário aceitar, e a exceção fica anotada.

Status: `revisado para avaliação` até o aceite; `aprovado` só depois dele.

Ajuste pedido muda **só** o que ele pediu; o resto fica idêntico. Depois do aceite, chame o professor.

## Regras do script

- ExtendScript em UTF-8 **com BOM**, `displayDialogs = DialogModes.NO` restaurado no `finally`.
- Documento RGB com o perfil incorporado; PSD com camadas; PNG com perfil.
- Não sobrescreva PSD ou PNG já mostrado. Fonte ausente é erro, nunca troca silenciosa.
- Antes de usar `getByName` ou duplicar, confira qual documento está ativo.
