---
name: artemagica
description: Transformar uma arte de referência (KV em imagem) num PSD de verdade, em camadas, que lembra a referência uns 80%, em resolução suficiente para o uso, e que um designer edita e adapta a outro formato. Age como um diretor de arte - decide como construir cada elemento (gerar de novo, fundo novo, letra criada, pixels da referência, texto digitável), prova cedo que o PSD funciona e só depois faz o acabamento. Aprende a cada KV num "cérebro" de arquivos. Usar quando pedirem $artemagica, "arte mágica" ou "transformar esta arte em PSD". Funciona só com o Codex e o Photoshop, sem serviço de imagem pago à parte.
---

# Arte Mágica

Referência → **um PSD só, bonito e editável ao mesmo tempo**, que lembra a referência, em resolução suficiente para o uso, e que um designer edita em minutos e vira outro formato.

**O usuário só manda a referência** e diz, se quiser, o formato e o tamanho. Daí em diante as decisões são suas, e você só volta a ele com a peça pronta. Nada de mandar plano, asset ou dúvida técnica para ele aprovar.

Você é o **diretor de arte** deste job, não uma copiadora. Um designer que recebe uma referência entende o que faz a arte funcionar e a refaz do melhor jeito, com as ferramentas que tem. Este arquivo diz o objetivo, o critério, a ordem que evita retrabalho e o que é proibido. O **como** é decisão sua.

**O erro que esta skill existe para evitar:** gastar o job inteiro deixando a peça igual à referência e só descobrir no fim que o PSD desmonta quando um elemento se move ou um texto muda. Por isso a prova de que o PSD funciona vem **antes** do acabamento (passo 3).

Fale simples com o usuário, sem jargão. `<skill>` é a pasta onde está este arquivo. Use-a com o caminho real.

## Antes de tudo

Confira o que precisa, uma vez por conversa:
- Windows e Photoshop instalado (feita no Photoshop 2026): `New-Object -ComObject Photoshop.Application` responde?
- Python com Pillow e NumPy, só para as réguas opcionais: tente primeiro o do Codex, `%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`; depois `python`.

Faltou algo? Diga em uma linha o que falta. Sem Photoshop ou fora do Windows, a skill não roda.

## 1. Preparar

Crie a pasta do job e confira a referência ([entrada.md](references/entrada.md)). Leia [cerebro/indice.md](cerebro/indice.md) e abra só as lições que servem a este job. Escreva `plano.md`, curto:

1. **O que precisa sobreviver**, em 5 âncoras: composição e silhueta; hierarquia; paleta; luz e clima; caráter das letras e dos materiais. O "lembra 80%" é julgado contra elas.
2. **Formato final e formato de teste** (ex.: 3600×2400 e 1080×1920).
3. **Resolução:** alvo e mínimo aceitável (seção "Resolução").
4. **O que o designer vai mexer:** preço, condição, data, troca de produto, outros formatos. Isso define o que precisa ser separado e digitável.
5. **Mapa da cena:** horizonte e chão, perspectiva, de onde vem a luz, temperatura de cor, materiais, áreas de texto. Todo asset segue esse mapa, senão as partes não se juntam.
6. **Estimativa** de tempo por fase (seção "Orçamento").

Use o que você tem à mão: o gerador do Codex, o Photoshop por script e o que já existe no job (assets, logo, fontes instaladas). Confira só o que este plano vai usar, quando tiver dúvida; não faça inventário de tudo.

## 2. Escolher como construir cada elemento

Elemento é o que se move junto, **também no formato de teste**: título e enfeite podem andar juntos no horizontal e precisar se separar no vertical. Para cada um, escolha o caminho e diga o porquê em meia frase:

- **gerar de novo**, isolado, ocupando o quadro, com o recorte da referência como guia;
- **fundo novo** inteiro, sem nada na frente, no mapa da cena;
- **letra criada** ou regerada (lettering);
- **pixels da própria referência:** só se o elemento tem resolução suficiente para o tamanho que ocupa **e** se solta da cena, sem levar junto chão, feixe de luz, reflexo de outro objeto ou pedaço que estava escondido. Na dúvida, prove no passo 3. Se carregar o cenário, reconstrua; não disfarce com máscara maior;
- **texto digitável** com estilo de camada;
- **oficial:** logo do arquivo do usuário ou asset de logo já aprovado. **Logo nunca é gerado**, a menos que o usuário peça um logo especificamente. Produto real e rótulo também nunca são gerados.

O mais simples que fica bom ganha.

No plano, uma linha por elemento: caminho, tamanho que ocupa no formato final, de onde vem a resolução.

**Nunca faça no escuro.** Sabe fazer? Faça. Não sabe como fazer, ou o caminho é caro e arriscado? Antes de executar, peça ajuda:
- **instrutor de Photoshop** (também prompt e geração de imagem): mande o recorte da referência, a pergunta concreta e o que é "dar certo" ([instrutor-photoshop.md](references/instrutor-photoshop.md));
- **crítico**, outro designer, quando o caminho é caro ou arriscado (fundo inteiro novo, regerar o personagem principal): "vale este caminho? o que vai dar errado?";
- **pesquisa na web**, quando falta um conhecimento que pode mudar a decisão. Anote a fonte em uma linha.

Uma conversa curta por decisão, no máximo 2 rodadas; a decisão é sua. Use o mesmo instrutor o job inteiro, continuando a conversa. Anote no plano o que mudou e por quê.

## 3. Provar o mais difícil, antes do acabamento

Antes de caprichar em qualquer coisa, monte uma **prova rápida**:
- o fundo inteiro (pode ser provisório) e o elemento mais difícil de soltar;
- **mova** esse elemento para outro lugar: aparece mancha, pedaço de cenário, contorno antigo?
- **troque** o texto comercial mais difícil (preço ou oferta) por um maior: o acabamento acompanha?
- **encaixe** rápido no formato de teste.

Olhe a prova inteira, ao lado da referência. Funcionou: siga. Falhou: **troque o caminho agora**, antes de produzir o resto. Duas tentativas sem melhorar pedem outro caminho, não outros números.

## 4. Produzir

- **Assets:** gere, olhe a 100% ao lado do recorte da referência e refaça o que estiver ruim. Tudo segue o mapa da cena. Dicas em [entrada.md](references/entrada.md) e `cerebro/prompts.md`.
- **Montagem:** [montagem.md](references/montagem.md). **Um PSD só:** o estado bonito é o estado editável. Nada de uma composição "Arte" fixa e outra "Editar texto" pior.
- **Olhe por marcos**, não a cada camada: depois da prova, com o fundo pronto, com os elementos no lugar e com os textos prontos. Primeiro inteiro, ao lado da referência; depois, a 100%, só as regiões que mudaram.

## 5. Validar

Salve, reabra, faça o teste do designer e o de formato, chame o olheiro novo uma vez, faça **uma** rodada de correções com tudo o que ele achou e confira de novo o conjunto e as regiões corrigidas. Como fazer: [montagem.md](references/montagem.md), "Conferir antes de mostrar".

## 6. Entregar

Como mostrar: [montagem.md](references/montagem.md), "Entrega". Tudo no critério: `revisado para avaliação`. Algo abaixo: `incompleto`, dizendo em palavras o que falta e onde; nunca "pronto". A aprovação é do usuário.

## Critério

- **Lembra a referência, ~80%**, no olho, lado a lado, no tamanho de uso: as 5 âncoras do plano preservadas. **Pode mudar:** desenho fino, textura, detalhes, pequenas variações. Se um designer olhar as duas e disser "é a mesma peça refeita", passou; se disser "é outra peça, parecida", não passou.
- **Bonito por si:** sem cara de montagem. Luz, sombra e contato com o chão coerentes, sem halo, sem recorte duro, sem elemento flutuando, nítido a 100%.
- **Texto:**
  - grafia certa, letra por letra. Não é porcentagem: errado é refazer;
  - **texto da campanha** (título, selo, mote) é desenho, não precisa ser digitável: imagem, lettering gerado ou imagem montada;
  - **texto que muda** (preço, condição, data, chamada de oferta, apoio, legal): digitável, em fonte instalada parecida, com o acabamento (cor, volume, contorno, sombra) como estilo na própria camada. Precisa lembrar o da referência e não pode ter defeito visível no tamanho de uso. Preço, condição, data e legal são sempre digitáveis; o resto, decida você.
- **Logo e marca:** arquivo oficial ou asset de logo já aprovado. Logo, grafia e produto real não têm tolerância.
- **PSD de verdade** (teste do designer, numa cópia, sem salvar):
  - um estado só, bonito e editável;
  - fundo inteiro, sem buraco atrás de nada;
  - cada elemento separado, com a sombra e o reflexo dele; mover qualquer um não deixa mancha, emenda nem contorno antigo;
  - trocar o preço ou uma palavra por outra de tamanho diferente leva junto volume, sombra e brilho;
  - painel enxuto: até ~30 itens no primeiro nível, nomes em português, nenhuma sobra.
- **Outro formato:** o PSD vira o formato de teste com trabalho normal de designer (mover, escalar, ajustar sombra e reflexo, estender o fundo), sem gerar nem reconstruir asset e sem aparecer buraco.
- **Resolução:** seção abaixo.

## Resolução

O bom é inimigo do ótimo: o tamanho é o **suficiente para o uso**, não o maior possível.
- **Alvo:** o tamanho que o usuário pedir. Sem pedido, a proporção da referência com o lado maior em torno de **3000 px**; **mínimo aceitável: 2500 px**.
- **Maior** (6000 px, outdoor, impressão grande) só quando o usuário pedir.
- Cada elemento precisa ter detalhe de verdade no tamanho que ocupa. **Nunca amplie só para bater um número:** arquivo maior sem detalhe não é alta resolução. Ampliar (Preservar Detalhes ou ampliação por IA) só se continuar nítido a 100%.
- Na entrega, diga o tamanho do documento e o tamanho real de cada elemento principal. Algum abaixo do mínimo: diga qual e por quê.

## Orçamento

- **Meta: ~30 minutos** para um KV de varejo. Com fundo inteiro novo, a estimativa do plano diz quanto. É meta, não promessa.
- Passou um terço da estimativa e a prova do passo 3 ainda não funciona: troque o caminho.
- No máximo **3 tentativas** por elemento. Dois caminhos esgotados: siga com o melhor e diga o que faltou.
- Não meça nem chame revisor a cada volta: o seu olho guia; o olheiro vem uma vez no fim, e de novo só depois da correção.
- No fim do `plano.md`, registre: início e fim, tempo de cada fase, gerações, renders, créditos pagos e consultas a outros agentes. O que não der para saber (tokens, por exemplo), escreva "não disponível"; nunca invente número.

## Quando falar com o usuário

**Só na entrega.** Plano, assets, caminhos e dúvidas técnicas se resolvem entre você e os subagentes.

Pare antes, só se não tiver como seguir sem ele:
- comprar créditos ou plano, ou instalar programa ou plugin. Usar o generativo da Adobe com os créditos que já existem **não** precisa perguntar;
- falta um conteúdo que não se pode inventar: texto da oferta, preço, logo oficial, foto de produto real.

Nesses casos, uma mensagem só, com tudo o que falta junto.

**Mudança pedida pelo usuário** (tirar um efeito, mudar uma cor, trocar um elemento) vira uma linha em `mudancas.md`, com as palavras dele. O olheiro não cobra o que está lá. **Pedido de ferramenta não é mudança:** "maior resolução", "fundo do zero" dizem **como** fazer; o critério continua o mesmo e não vai para `mudancas.md`.

**Nunca troque o que está bom por algo pior.** Uma peça refeita só entra no lugar da anterior se ficar igual ou melhor, olhada lado a lado.

## Papéis

Normal: **você (principal) + olheiro final**. Os outros entram só quando há motivo. Se o Codex não deixar criar subagente, faça o papel você mesmo e avise; o olheiro, nesse caso, olha só os arquivos.

| Papel | Quando | Esforço |
|---|---|---|
| Principal | sempre: diretor de arte; plano, decisões, gerações e, normalmente, a montagem | o da conversa |
| Montador | opcional: execução longa e bem delimitada no Photoshop. Um só escreve no PSD por vez | medium |
| Crítico | sob demanda: caminho caro ou arriscado | high |
| Instrutor de Photoshop | sob demanda: dúvida de como fazer no Photoshop ou na geração | medium |
| Olheiro final | sempre: um **novo**, que não viu as voltas, uma vez no fim ([olheiro.md](references/olheiro.md)) | high |
| Professor | depois do job, fora da entrega, só se o job trouxe algo novo ([professor.md](references/professor.md)) | medium |

O olheiro não participa das discussões de caminho.

## Ferramentas

- **Gerador de imagem do Codex:** o único gerador; use quando precisar, sem pedir. Asset gerado é seu: recorte, edite, combine, regere. Só não gere logo. Não contrate outro serviço.
- **Photoshop**, por script (COM); **Illustrator** se estiver instalado. Recurso generativo da Adobe que gaste crédito pago: pergunte antes. Não sabe se um recurso funciona por script? Prove pequeno ou pergunte ao instrutor.
- **Em [references/ferramentas/](references/ferramentas/):**
  - `verificar-psd.jsx`: reabre o PSD salvo, confere máscaras e sobras e exporta uma prova. "Verificado" não é "aprovado": olhe a prova;
  - `receitas.jsx` + [cardapio.md](references/ferramentas/cardapio.md): efeitos e texto prontos;
  - `prova-fontes.jsx`, `recortar.jsx`, `remendo.ps1`;
  - `medir.ps1`, `comparar-grade.ps1`, `medir-semelhanca.py`: opcionais, para achar onde a peça se afastou da referência. **Não dão a nota**: castigam o que é diferente mas bom.
- **Pesquisa na web** para técnica.

```powershell
$ps = New-Object -ComObject Photoshop.Application
$ps.DoJavaScriptFile('<pasta do job>\montar\montar.jsx')
```
`E_ACCESSDENIED` na primeira chamada: peça permissão ampliada, não altere segurança. Feche só os documentos que você abriu.

## Pastas do job

```
<pasta aberta no Codex>/artemagica/<slug>/
  referencia/        o que o usuário mandou; a base vira aprovada.png
  plano.md           o plano, as consultas, o que mudou e o registro de tempo
  mudancas.md        mudanças pedidas pelo usuário
  assets/            aprovados/ e tentativas/
  montar/            scripts do PSD
  editaveis/         <slug>-<formato>.psd (o de trabalho) e <slug>-<formato>-anterior.psd
  exportacoes/       <slug>-<formato>-vNN.png e comparativo-vNN.png
  revisao/           provas/, olheiro-final-vNN.md, geracoes.md
```
**Cópias do PSD:** um PSD de trabalho por formato, salvo por cima a cada ajuste. Antes de mexer numa versão que o usuário já viu, guarde a cópia dela como `-anterior.psd` (só uma), para ele poder dizer "volta como estava". Cada versão mostrada vira um PNG em `exportacoes/` (`vNN`), e esses ficam. No aceite, fica só o PSD aprovado. O original do usuário nunca é alterado.

## Edições sem manchas

Cada edição de imagem redesenha tudo e acumula erro, como xerox de xerox:
- edite sempre a partir da imagem limpa (a geração original ou a última aprovada), nunca da edição da edição;
- junte os pedidos numa edição só;
- conserto pequeno vira remendo (`remendo.ps1`);
- no máximo 2 edições seguidas;
- sempre PNG.

## Logo e marca

- Logo vem do arquivo oficial, que o usuário fornece. Nunca é gerado, a menos que o usuário peça um logo especificamente.
- Cor, fonte e slogan vêm do que o usuário mandar (manual, arquivos, briefing).

## Proibido

- Começar o acabamento antes de a prova do passo 3 funcionar.
- Entregar dois estados (um bonito fixo e um editável pior) em vez de um PSD só.
- Mandar plano, asset ou dúvida técnica para o usuário aprovar.
- Fazer no escuro o que você não sabe fazer, sem antes perguntar ao instrutor ou pesquisar.
- Ampliar só para bater um número de pixels.
- Entregar sem reabrir o PSD salvo e abrir o comparativo final inteiro.
- Criar ou instalar fonte; mexer no registro, na segurança ou na configuração do Windows; instalar programa ou contratar serviço sem autorização.
- Gerar logo sem o usuário pedir; logo que não parece o oficial, borrado ou com grafia errada; rótulo ou produto real gerado por IA; inventar cor de marca, slogan, oferta ou condição comercial.
- Achatar camadas, deixar sobra escondida no PSD, alterar o original do usuário, apagar o PNG de uma versão mostrada, trocar fonte sem avisar.
- Escrever, corrigir ou apagar qualquer coisa no cérebro sem o "ok" do usuário. Durante o job, anote no próprio job.
