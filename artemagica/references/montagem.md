# Montar, conferir, testar e entregar

Lido pela conversa principal e pelo montador. São dicas: o que deu certo até hoje. Achou um caminho melhor, use-o e conte na aula. Antes de cada parte difícil, pesquise e pergunte ao instrutor da ferramenta (`SKILL.md`). A cada camada que entrar, exporte e olhe ao lado da referência: não deixe para descobrir o problema só no fim.

## Montar

1. **Documento** no tamanho do formato final, no perfil de cor do destino combinado (sem combinado: sRGB). Converta o perfil de tudo o que entrar.
2. **Fundo:** uma camada inteira, sem buraco atrás de nada (o fundo novo gerado, ou a referência com o que fica atrás dos elementos reconstruído). Luz e névoa da cena em camadas próprias por cima.
3. **Elementos:** cada um num objeto inteligente, no lugar e no tamanho do plano. A sombra de contato e o reflexo de cada um ficam no mesmo grupo dele, para irem juntos quando o designer mover.
4. **Texto da campanha** (título, selo, mote): imagem ou render, como objeto inteligente. Não precisa de versão digitável.
5. **Texto que muda:** camada de texto em fonte instalada parecida (prova de fontes, escolha no olho):
   - meça a altura e a largura de cada linha contra a referência e reserve o espaço entre as palavras;
   - material, volume, contorno e sombra como **estilo de camada na própria camada de texto**, nunca cópias soltas que não acompanham a troca de palavra;
   - brilho pontual (um reflexo pequeno numa letra) numa camada própria, no mesmo grupo da palavra.
6. **Integração:** luz rebatida, sombra de contato e cor geral, cada uma numa camada nomeada, com máscara. É aqui que a peça deixa de parecer montagem.
7. **Mudanças do usuário:** confira `mudancas.md`.

Use as receitas do [cardápio](ferramentas/cardapio.md) e as técnicas do cérebro.

## Organização do PSD (para o designer)

De baixo para cima, nomes em português, até ~30 itens no primeiro nível:
```
Fundo | fundo inteiro + luz + ajustes de cor
Pessoas e personagens | um objeto inteligente por pessoa, com a sombra dela
Elementos | produtos e objetos, cada um com sombra e reflexo
Efeitos | fumaça, névoa, brilhos
Textos | título da campanha (imagem) e textos digitáveis
Selo e assinatura | oficial
```
Antes de entregar, apague as provas, os grupos de tentativa e as camadas temporárias.

## Conferir antes de mostrar

1. **Olhe** a prova inteira no tamanho de uso, ao lado da referência, e depois a 100%: lembra? está bonito? tem cara de montagem? Itens que costumam passar batido em `cerebro/olho.md`.
2. **Reabra o PSD salvo** com `verificar-psd.jsx` (recusa se o PSD estiver aberto; conta itens, aponta sobras e máscaras vazias, exporta uma prova). Abra a prova e olhe.
3. **Teste do designer**, numa cópia, sem salvar, feito como um designer faria à mão:
   - troque uma palavra de um texto que muda por outra de tamanho diferente e troque o preço;
   - mova o título e mova um elemento (personagem, produto ou logo): não pode aparecer mancha, emenda ou contorno antigo.
   Exporte para `revisao/provas/da-<acao>.png` e olhe.
4. **Teste de formato**, numa cópia: mude o tamanho da tela para o novo formato e só mova e escale. Exporte para `revisao/provas/formato-<nome>.png` e olhe.
5. **Olheiro novo** ([olheiro.md](olheiro.md)), uma vez.
6. **Comparativo** `exportacoes/comparativo-vNN.png`: referência | PSD, no mesmo tamanho. Abra inteiro antes de enviar.

## Entrega

Mostre ao usuário, nesta ordem:
- primeiro o comparativo lado a lado;
- o caminho do PSD e dos assets principais (`assets/aprovados/`);
- uma tabela curta: elemento | caminho usado | nota do olheiro | o que falta;
- o resultado dos testes do designer e de formato;
- o tempo gasto e as gerações usadas, contra a estimativa do plano.

Status: `revisado para avaliação` até o aceite; `aprovado` só depois dele. Com algo abaixo do critério, nunca diga "pronto": diga em palavras o que ficou pior e onde.

Ajuste pedido muda **só** o que ele pediu; o resto fica idêntico. Depois do aceite, chame o professor.

## Regras do script

- ExtendScript em UTF-8 **com BOM**, `displayDialogs = DialogModes.NO` restaurado no `finally`.
- Documento RGB com o perfil incorporado; PSD com camadas; PNG com perfil.
- PSD: salve por cima o de trabalho; antes, se a versão já foi mostrada, guarde a `-anterior.psd` (regra em `SKILL.md`, "Pastas do job"). PNG de versão mostrada nunca é sobrescrito. Fonte ausente é erro, nunca troca silenciosa.
- Antes de usar `getByName` ou duplicar, confira qual documento está ativo.
