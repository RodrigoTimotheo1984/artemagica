---
name: artemagica
description: Recriar uma arte (KV) no Photoshop em camadas editáveis, com 95% de semelhança, a partir de uma imagem pronta ou de um briefing. Monta com os pixels do próprio molde em camadas com máscara, reconstrói só o que fica escondido, consulta um técnico de Photoshop e prova que o PSD é fácil de editar e vira outro formato. Aprende a cada KV num "cérebro" de arquivos. Usar quando pedirem $artemagica, "arte mágica" ou "recriar esta imagem no Photoshop igual". Funciona só com o Codex e o Photoshop, sem serviço de imagem pago à parte.
---

# Arte Mágica

Imagem (ou briefing) → **PSD em camadas igual à arte**, que um designer edita em minutos e que vira outro formato sem gerar nada.

Este arquivo diz **o quê**, **até onde** e **o que é proibido**. O **como** está nas dicas de `references/`: são ponto de partida, não receita. Você conhece o Photoshop: use o seu julgamento, e se achar um caminho melhor, use-o e conte na aula. Travou? Pergunte ao técnico. **O resultado é o que importa:** se levar 2 horas, leva.

**Olhe sempre o que você fez.** Depois de cada passo (uma geração, um recorte, uma camada, uma volta), abra o resultado, inteiro e a 100%, ao lado do alvo, e pergunte: "o que está diferente, estranho ou com cara de montagem?". Ajuste e olhe de novo antes de seguir. Nada vai para o usuário sem você ter visto antes. Os números ajudam a achar o problema; quem decide se está bom é o seu olho.

Fale simples com o usuário, sem jargão. `<skill>` é a pasta onde está este arquivo. Use-a com o caminho real.

## Antes de tudo

1. **Confira o que precisa,** uma vez por conversa:
   - Windows e Photoshop instalado (feita no Photoshop 2026): `New-Object -ComObject Photoshop.Application` responde?
   - Python com Pillow e NumPy: tente primeiro o do Codex, `%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`; depois `python`. Sem nenhum, peça autorização antes de instalar.

   Faltou algo? Diga em uma linha o que falta. Sem Photoshop ou fora do Windows, a skill não roda.
2. **Leia o cérebro:** [cerebro/indice.md](cerebro/indice.md). Abra só as lições que combinam com o job e diga em uma linha quais vai usar.

## Até onde (o piso)

Nada é 100%. O piso é **95%**.

- **Semelhança:** 95% no quadro inteiro **e** em cada pedaço (personagem, produto, selo, cada linha de texto, fundo). Meça com a régua (`references/ferramentas/medir-semelhanca.py`, que converte a cor pelo perfil) e confirme no olho, lado a lado e ampliado. A régua aponta onde olhar; o olho decide. Nota sem a cor convertida não vale. Olhe também o anúncio inteiro no tamanho de uso: leitura, hierarquia, luz, sombra e contato com o chão.
- **Texto:**
  - grafia certa, letra por letra. Não é porcentagem: errado é refazer;
  - espaço entre palavras e tamanho de cada letra iguais aos do molde, sem sumir nem crescer;
  - o PSD **abre igual à arte**, com o lettering do molde. Uma segunda composição de camadas, "Editar texto", traz o mesmo texto em fonte instalada parecida, com piso de **90%** no olho;
  - preço, data, condição e legal: sempre texto digitável.
- **Teste do designer** (numa cópia, sem salvar, cada ação feita como um designer faria à mão, do achar a camada ao conferir):
  - painel enxuto: até ~30 itens no primeiro nível, nomes em português e **nenhuma sobra** (nada de "Camada 1", provas ou grupos de tentativa);
  - trocar uma palavra por outra **de tamanho diferente** muda junto o volume, a sombra e o brilho dela (se a frente da letra muda e o volume continua com as letras antigas, reprova);
  - mover personagem ou produto leva junto a sombra e o reflexo, e o fundo atrás dele está inteiro;
  - um designer troca preço, palavra e posição e move um personagem à mão em menos de 1 minuto: poucos cliques, camada fácil de achar pelo nome. A arte não tem preço ou personagem? Anote "não se aplica"; não invente oferta.
- **Teste de formato:** virar o PSD em outro formato (ex.: 3600×2400 → 1080×1920) só movendo e escalando camadas, **sem gerar nada**.
- **Resolução:** a do formato final, com detalhe de verdade a 100%. Ampliar no Photoshop só se continuar nítido a 100% (fundo desfocado amplia bem; rosto, mão, letra e logo, quase nunca). Caminhos em [pecas.md](references/pecas.md).

Ficou abaixo do piso e não sobe mais? Mostre ao usuário o melhor resultado, com as notas e o que faltou. Quem decide é ele; se ele aceitar, anote a exceção com as notas reais.

## Aprovações do usuário

Explícitas e uma a uma. Mostre, pergunte e **pare**:
1. o molde (a imagem que vai ser copiada);
2. a lista de peças (o que vem do molde e o que será gerado);
3. cada asset gerado em alta, um por vez;
4. a entrega.

Entre uma aprovação e outra, trabalhe sozinho: veja, ajuste e reveja quantas vezes precisar.

**Mudança pedida pelo usuário** (ex.: tirar um efeito, mudar uma cor, trocar um elemento) vira um **alvo novo e separado** (`molde/alvo-v01.png`, depois `alvo-v02.png`…, nunca por cima do anterior) e uma linha em `mudancas.md`, com as palavras dele e o alvo que ela gerou. Ninguém "corrige" de volta. **Alvo vigente** = o `alvo-vNN.png` mais recente; sem nenhum, `molde/aprovado.png`.

## O caminho (dicas)

| Passo | Leia |
|---|---|
| 1. Molde: imagem pronta, ou briefing → 4 layouts → o usuário escolhe | [entrada.md](references/entrada.md) |
| 2. Peças: elementos como objetos inteiros; gerar em alta só o que precisa | [pecas.md](references/pecas.md) |
| 3. Montar fatiando o molde, conferir, testar e entregar | [montagem.md](references/montagem.md) |
| 4. Olheiro novo antes da entrega | [olheiro.md](references/olheiro.md) |
| 5. Aula depois do aceite | [professor.md](references/professor.md) |

## Papéis

Todos no modelo escolhido na conversa. Se o Codex não deixar criar subagente, faça o papel você mesmo e avise; o olheiro, nesse caso, olha só os arquivos finais.

| Papel | Faz | Esforço |
|---|---|---|
| Principal | conversa, aprovações, gerações, mede e decide as voltas | o da conversa |
| Montador | executa no Photoshop por script | medium |
| Técnico | consultor de Photoshop: ensina, pode falar direto com o montador, não mexe no PSD | high |
| Olheiro final | um **novo**, que não viu as voltas; acha diferenças e bloqueios | high |
| Professor | aula depois do aceite | high |

Use o **mesmo técnico** o job inteiro, continuando a conversa com ele. Como consultar: [tecnico.md](references/tecnico.md).

## Ferramentas

- **Gerador de imagem do Codex:** o único gerador. Não contrate outro serviço.
- **Photoshop**, por script (COM), com todas as ferramentas; **Illustrator** se estiver instalado. Recurso generativo da Adobe que gaste crédito pago: pergunte antes.
- **Em [references/ferramentas/](references/ferramentas/):**
  - `medir-semelhanca.py`: a régua;
  - `medir.ps1`: texto, cor e fonte;
  - `receitas.jsx` + [cardapio.md](references/ferramentas/cardapio.md);
  - `verificar-psd.jsx`: reabre o PSD salvo, confere máscaras, composições e sobras;
  - `prova-fontes.jsx`, `recortar.jsx`, `remendo.ps1`, `comparar-grade.ps1`.
- **Pesquisa na web** para técnica de Photoshop.

```powershell
$ps = New-Object -ComObject Photoshop.Application
$ps.DoJavaScriptFile('<pasta do job>\montar\montar.jsx')
```
`E_ACCESSDENIED` na primeira chamada: peça permissão ampliada, não altere segurança. Feche só os documentos que você abriu.

## Pastas do job

```
<pasta aberta no Codex>/artemagica/<slug>/
  referencia/        cópias do que o usuário mandou
  molde/             aprovado.png e, se o usuário mudou algo, alvo-v01.png, alvo-v02.png…
  mudancas.md        mudanças pedidas pelo usuário
  pecas.md           elementos, decisão e tamanho final
  assets/            aprovados/ e tentativas/
  montar/            scripts do PSD
  editaveis/         <slug>-<formato>.psd (o de trabalho) e <slug>-<formato>-anterior.psd
  exportacoes/       <slug>-<formato>-vNN.png e comparativo-vNN.png
  revisao/           medidas/, provas/, olheiro-final-vNN.md, geracoes.md
```
**Cópias do PSD:** um PSD de trabalho por formato, salvo por cima a cada ajuste. Antes de mexer numa versão que o usuário já viu, guarde a cópia dela como `-anterior.psd` (só uma; a mais antiga é apagada), para ele poder dizer "volta como estava". Cada versão mostrada vira um PNG leve em `exportacoes/` (`vNN`), e esses ficam. No aceite, fica só o PSD aprovado e a cópia anterior é apagada. O histórico do Photoshop some ao fechar o arquivo: não conte com ele. O original do usuário nunca é alterado. Guarde cada medição com o nome da versão (`revisao/medidas/vNN.txt`).

## Edições sem manchas

Cada edição de imagem redesenha tudo e acumula erro, como xerox de xerox:
- edite sempre a partir da imagem limpa (a geração original ou a última aprovada), nunca da edição da edição;
- junte os pedidos numa edição só;
- conserto pequeno vira remendo (`remendo.ps1`);
- no máximo 2 edições seguidas;
- sempre PNG.

## Logo e marca

- Logo plano: refeito com o arquivo oficial, que o usuário fornece.
- Logo criativo (3D, material, luz da cena) pode ficar da IA, se o desenho estiver o mais parecido possível com o oficial, com a grafia certa e nítido no tamanho final. Confira lado a lado.
- Cor, fonte e slogan vêm do que o usuário mandar (manual, arquivos, briefing).

## Proibido

- Avançar sem aprovação.
- Dar nota sem medir com a cor convertida, ou chamar de "pequena" uma diferença que não foi medida.
- Entregar sem reabrir o PSD salvo, ligar as duas composições e abrir o comparativo final inteiro.
- Criar ou instalar fonte; mexer no registro, na segurança ou na configuração do Windows; instalar programa ou contratar serviço sem autorização.
- Logo que não parece o oficial, borrado ou com grafia errada; rótulo ou produto real gerado por IA; inventar cor de marca, slogan, oferta ou condição comercial.
- Achatar camadas, deixar sobra escondida no PSD, alterar o original do usuário, apagar o PNG de uma versão mostrada, trocar fonte sem avisar.
- Escrever, corrigir ou apagar qualquer coisa no cérebro (lição, técnica, prompt) sem o "ok" do usuário. Durante o job, anote no próprio job; o cérebro só muda na aula.
- Ficar em loop:
  - 3 voltas sem a nota de um pedaço subir: mude a abordagem, não os números;
  - 3 abordagens esgotadas: mostre ao usuário;
  - 6 tentativas num asset sem aprovação: pare e converse.
