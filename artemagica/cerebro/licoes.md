# Lições (artemagica)

Gerais, com condição e números. Origem entre parênteses. Só entra com o "ok" do usuário.

## 1. Técnico para consultar + piso alto = resultado
Com um técnico de Photoshop para consultar e um piso alto, o agente não para antes da hora. Num teste, um elemento subiu de 58,3% para 96,1% quando a remontagem deu lugar aos pixels do molde. **Mas o número precisa ser medido certo.** No quadro inteiro, a prévia sem perfil de cor mostrava 98,6%; com a cor convertida, eram 92,6% com as letras fixas e 82,9% com o texto editável. Nenhuma dessas notas prova 90% nas letras isoladas. O Photoshop levou cerca de 2h20. Medir **por pedaço**, além do total, mostra onde está o pior. (outdoor, 11/2026)

## 2. Asset aprovado é oficial
O usuário aprova cada asset um a um. Aprovado, ele faz parte da arte, mesmo diferente do molde original. Quando um asset aprovado muda o desenho, faz-se um alvo novo com ele (`molde/alvo-vNN.png`), aprovado pelo usuário. A régua e o olheiro medem cada pedaço, **inclusive o interior do asset**, contra esse alvo. (o usuário, 02/11/2026)

## 3. Fonte instalada nunca é a do molde
Nenhuma fonte instalada costuma ser igual ao lettering de um molde gerado. O que aproxima é o ajuste fino: caixas medidas (`medir.ps1 texto`), largura de cada linha até ~2%, prova de fontes com 6–12 candidatas e **escolha final no olho**. A nota mais alta nem sempre é a melhor: uma fonte pode ganhar na medida e ficar espaçada demais. Precisou de tracking abaixo de ~−40 para caber? A fonte é larga demais. Lettering criativo não vira fonte comum só para facilitar. (10/2026)

## 4. Fatiar o molde em vez de remontar
Quando o molde tem resolução suficiente para o formato final, a imagem dele já está certa, então use os pixels dela:
- o fundo é o molde inteiro, e só se reconstrói o que fica escondido atrás dos elementos;
- cada elemento é uma cópia do tamanho da tela, no mesmo lugar, com máscara no contorno (com a sombra e o reflexo dele).

Não reposicione pelos limites do recorte. Não troque o fundo inteiro por um gerado limpo: ele muda detalhes e contraste. Repare também o que aparece quando um objeto se move, incluindo onde dois objetos se encostam. (outdoor, 11/2026: um elemento de 58,3% para 96,1%)

## 5. Nota só com a cor convertida
O perfil de cor dá o significado das cores do arquivo. Sem ele, a mesma imagem pode dar outra nota. Converta os dois arquivos para sRGB antes de medir. Guarde juntos, por versão: a imagem medida, o alvo, as caixas e a nota, sem sobrescrever a prévia que gerou a nota. (outdoor, 11/2026: a mesma composição deu 98,6% lida sem perfil e 92,6% com perfil; não foi a arte que piorou)

## 6. Conferir o arquivo salvo, não o painel
Uma camada pode aparecer no painel e não funcionar no arquivo: uma máscara toda branca não recorta nada. Uma composição pode ligar camadas que não devia, e o quadro sai com a cor errada. Antes de mostrar:
- reabra o PSD;
- confira o conteúdo das máscaras (`verificar-psd.jsx`);
- ligue cada composição, exporte e olhe;
- abra o comparativo inteiro.

(outdoor, 11/2026)

## 7. Texto: letra por letra e espaço entre palavras
- Confira o tamanho de cada letra contra o alvo: às vezes só uma é maior.
- Preserve o vão entre as palavras do alvo **antes** de esticar cada linha até a largura. Se não, o volume e a serifa comem o espaço e as palavras grudam.
- Volume e sombra da letra vão como estilo de camada na própria camada de texto. Cópias soltas não acompanham a troca de palavra: a frente muda e o volume continua com as letras antigas.
- O acabamento (material, sombra, espaço) pesa mais que o nome da fonte.
- A nota da caixa de uma linha inclui o fundo entre as letras: não prova sozinha o desenho das letras.

(outdoor, 11/2026)
