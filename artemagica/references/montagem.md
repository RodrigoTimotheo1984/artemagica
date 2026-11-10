# Montar, conferir, testar e entregar

Lido pela conversa principal e pelo montador. São dicas: o que deu certo até hoje. Achou um caminho melhor, use-o e conte na entrega. Não sabe como fazer uma parte? Pergunte ao instrutor da ferramenta antes (`SKILL.md`).

## Montar

O PSD é **um estado só**: o que está bonito é o que o designer edita. Sem composições "Arte" e "Editar texto".

1. **Documento** no tamanho do formato final (seção "Resolução" da `SKILL.md`), no perfil de cor do destino combinado (sem combinado: sRGB). Converta o perfil de tudo o que entrar.
2. **Fundo:** uma camada inteira, sem buraco atrás de nada, com sobra para o formato de teste. Luz e névoa da cena em camadas próprias por cima.
3. **Elementos:** cada um num objeto inteligente incorporado, no lugar e no tamanho do plano. A sombra de contato e o reflexo de cada um ficam no mesmo grupo dele, para irem juntos quando o designer mover.
4. **Texto da campanha** (título, selo, mote): imagem ou render, como objeto inteligente. Não precisa de versão digitável.
5. **Texto que muda:** camada de texto em fonte instalada parecida (prova de fontes, escolha no olho):
   - meça a altura e a largura de cada linha contra a referência e reserve o espaço entre as palavras;
   - material, volume, contorno e sombra como **estilo de camada na própria camada de texto**, nunca cópias soltas que não acompanham a troca de palavra;
   - textura do material: sobreposição de padrão no estilo, ou uma camada de textura presa ao texto (máscara de recorte), para acompanhar a troca;
   - brilho pontual (um reflexo pequeno numa letra) numa camada própria, no mesmo grupo da palavra.
6. **Integração:** luz rebatida, sombra de contato e cor geral, cada uma numa camada nomeada, com máscara. É aqui que a peça deixa de parecer montagem.
7. **Mudanças do usuário:** confira `mudancas.md`.

Use as receitas do [cardápio](ferramentas/cardapio.md) e as técnicas do cérebro. A receita não tem o efeito que você precisa (chanfro, gradiente, textura)? Pergunte ao instrutor e faça no próprio estilo de camada; não crie um script enorme para cada detalhe.

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

1. **Olhe** a prova inteira no tamanho de uso, ao lado da referência: lembra (as 5 âncoras do plano)? está bonito? tem cara de montagem? Depois, a 100%, os detalhes; itens que costumam passar batido em `cerebro/olho.md`.
2. **Reabra o PSD salvo** com `verificar-psd.jsx` (recusa se o PSD estiver aberto; conta itens, aponta sobras, máscaras vazias e composições, exporta uma prova). Abra a prova e olhe.
3. **Teste do designer**, numa cópia, sem salvar, feito como um designer faria à mão:
   - troque uma palavra de um texto que muda por outra de tamanho diferente e troque o preço;
   - mova o título e mova os elementos principais: não pode aparecer mancha, emenda, pedaço de cenário ou contorno antigo.
   Exporte para `revisao/provas/da-<acao>.png` e olhe.
4. **Teste de formato**, numa cópia: mude a tela para o formato de teste e faça o trabalho normal de um designer (mover, escalar, ajustar sombra e reflexo, estender o fundo). Sem gerar nem reconstruir asset. Exporte para `revisao/provas/formato-<nome>.png` e olhe.
5. **Olheiro novo** ([olheiro.md](olheiro.md)), uma vez. Corrija tudo o que ele achou numa rodada só e confira de novo o conjunto e as regiões corrigidas.
6. **Comparativo** `exportacoes/comparativo-vNN.png`: referência | PSD, no mesmo tamanho. Abra inteiro antes de enviar.

## Entrega

Mostre ao usuário, nesta ordem:
- primeiro o comparativo lado a lado;
- o caminho do PSD e dos assets principais (`assets/aprovados/`);
- uma tabela curta: elemento | caminho usado | tamanho real em px | o que falta;
- o tamanho do documento e o resultado dos testes do designer e de formato;
- em poucas linhas: o tempo gasto contra a estimativa do plano; quantas gerações, renders e créditos pagos usou; e o que as consultas (crítico, instrutores) mudaram no plano.

Status: `revisado para avaliação` só com tudo no critério; senão, `incompleto`, dizendo em palavras o que ficou pior e onde. `aprovado` só depois do aceite do usuário.

Ajuste pedido muda **só** o que ele pediu; o resto fica idêntico.

## Regras do script

- ExtendScript em UTF-8 **com BOM**, `displayDialogs = DialogModes.NO` restaurado no `finally`.
- Documento RGB com o perfil incorporado; PSD com camadas; PNG com perfil.
- PSD: salve por cima o de trabalho; antes, se a versão já foi mostrada, guarde a `-anterior.psd` (regra em `SKILL.md`, "Pastas do job"). PNG de versão mostrada nunca é sobrescrito. Fonte ausente é erro, nunca troca silenciosa.
- Antes de usar `getByName` ou duplicar, confira qual documento está ativo.
