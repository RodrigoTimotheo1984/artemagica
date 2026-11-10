# Lições (artemagica)

Gerais, com condição e números de partida. Origem entre parênteses. Só entra com o "ok" do usuário.

## 1. Provar cedo que o PSD funciona
O trabalho todo pode ir para manter a peça igual à referência e, só no fim, mostrar que o fundo está preso aos elementos: ao mover um deles, aparecem chão, luz e restos da posição antiga, e o texto digitável perde o material. Prove antes do acabamento: fundo inteiro, mover o elemento mais difícil, trocar o texto comercial e encaixar no outro formato. Falhou? Mude o caminho na hora. (Natal Gigante, 11/2026: 45 minutos e o resultado foi a arte recortada em camadas)

## 2. Lembrar 80%, não copiar pixel
O usuário quer o que um designer faria com a referência: refazer do melhor jeito, lembrando ~80%, com tudo funcionando. Perseguir a nota da régua (90–95%) leva a fatiar a referência e a gastar horas. A régua só aponta onde a peça se afastou; quem julga é o olho. (o usuário, 10/11/2026)

## 3. Fonte instalada raramente é a do lettering da referência
O que aproxima é o ajuste fino: caixas medidas (`medir.ps1 texto`), largura de cada linha até ~2%, prova de fontes com 6–12 candidatas e **escolha final no olho**. A nota mais alta nem sempre é a melhor: uma fonte pode ganhar na medida e ficar espaçada demais. Precisou de tracking abaixo de ~−40 para caber? A fonte é larga demais. Lettering criativo não vira fonte comum só para facilitar: título da campanha pode ser imagem. (10/2026)

## 4. Pixels da referência: só o que se solta
Usar os pixels da referência é rápido e fica fiel, mas só serve quando o elemento tem resolução para o tamanho que ocupa **e** se solta da cena. Uma região que inclui chão, feixe de luz, reflexo de outro objeto ou partes escondidas não é um asset: ao mover, o cenário vai junto. Confira movendo o recorte sobre o fundo limpo; se carregar o cenário, regere ou reconstrua. Não reposicione pelos limites do recorte e repare onde dois objetos se encostam. (outdoor e Natal Gigante, 11/2026)

## 5. Medir só com a cor convertida
Se for medir (opcional), converta os dois arquivos para sRGB antes: sem o perfil de cor, a mesma imagem dá outra nota. (outdoor, 11/2026: a mesma composição deu 98,6% lida sem perfil e 92,6% com perfil; não foi a arte que piorou)

## 6. Conferir o arquivo salvo, não o painel
Uma camada pode aparecer no painel e não funcionar no arquivo: uma máscara toda branca não recorta nada. Antes de mostrar:
- reabra o PSD;
- confira o conteúdo das máscaras (`verificar-psd.jsx`);
- exporte, abra a prova e olhe;
- abra o comparativo inteiro.

(outdoor, 11/2026)

## 7. Texto: letra por letra e espaço entre palavras
- Confira o tamanho de cada letra contra a referência: às vezes só uma é maior.
- Preserve o vão entre as palavras **antes** de esticar cada linha até a largura. Se não, o volume e a serifa comem o espaço e as palavras grudam.
- Volume e sombra da letra vão como estilo de camada na própria camada de texto. Cópias soltas não acompanham a troca de palavra: a frente muda e o volume continua com as letras antigas.
- O acabamento (material, sombra, espaço) pesa mais que o nome da fonte.

(outdoor, 11/2026)

## Superadas (10/11/2026)
- "Técnico + piso alto de 90–95% = resultado" e "fatiar o molde em vez de remontar": eram do modo cópia. Viraram as lições 2 e 4.
- "o usuário aprova cada asset; asset aprovado vira alvo novo": o usuário não aprova mais plano nem asset; quem confere é o próprio job (prova cedo e olheiro).
