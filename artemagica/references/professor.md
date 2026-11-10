# Professor e cérebro (artemagica)

A skill aprende a cada KV. O que aprende fica no **cérebro**, `cerebro/`, dentro da pasta da skill: arquivos de texto que o Codex lê e que o usuário consegue abrir. Lição errada se corrige apagando a linha.

O professor **não faz parte da entrega**: a peça vai para o usuário sem esperar a aula. Ele só é chamado depois, se o job trouxe algo novo.

## O que tem no cérebro

| Arquivo | Guarda | Quem lê |
|---|---|---|
| `indice.md` | Uma linha por lição ou técnica, com etiquetas e o caminho. **Lido no começo de todo job** | todos |
| `licoes.md` | Lições gerais: o que funciona, o que o usuário recusa e por quê, decisões de processo | principal, olheiro |
| `olho.md` | Lista do que costuma passar batido. Ordem = o mais esquecido primeiro | olheiro |
| `tecnicas/<nome>.md` | Uma técnica por arquivo: passo a passo com números, quando usar, de quais jobs veio | instrutores, montador |
| `prompts.md` | Prompts de geração que deram certo e errado, por tipo, e o tamanho real de cada gerador | principal |
| `historico.md` | Uma linha por KV: data, job, resultado, tempo, gerações, créditos, o que o usuário disse | principal |

## A aula (depois do fim do job)

Depois que o usuário aceitou a peça, ou a recusou, ou o job parou. Job aceito ensina o que funciona; job não aceito ensina o que **não** funcionou, e assim é marcado.

1. O professor (subagente) lê o que o job deixou:
   - `plano.md` (caminhos, consultas e o registro de tempo) e `revisao/olheiro-final-*.md`;
   - `mudancas.md` e as provas dos testes do designer e de formato;
   - `revisao/geracoes.md` (prompts aprovados e recusados, com o motivo);
   - o que o usuário disse (a principal resume em até 10 linhas no pedido).
2. Ele escreve uma **proposta de aula** em `revisao/aula.md`, só com o que for **novo e comprovado** no job:
   - **no máximo ~3 lições**, as que mais vão ajudar no próximo KV, cada uma com a condição em que vale;
   - técnica nova que deu certo vira `tecnicas/<nome>.md` (ou melhora a parecida);
   - itens para o `olho.md`: o que só o olheiro final ou o usuário acharam;
   - prompts para o `prompts.md`;
   - a linha do `historico.md` (esta sempre entra).
3. A conversa principal mostra a aula ao usuário **em linguagem simples**: "aprendi isto: …". Ele aprova, corta ou corrige.
4. Com o "ok", o professor escreve no cérebro e atualiza o `indice.md`.

## Regras do cérebro

- **Geral, nunca preso a um job.** Escreva "objeto sobre superfície brilhante tem reflexo invertido", e não "o selo do Natal tem reflexo". O job entra só como origem: "(KV de Natal, 11/2026)".
- **Condição e números de partida:** toda lição diz quando vale. Número é ponto de partida, não lei.
- **Sem repetição:** antes de escrever, procure a lição parecida e melhore ela.
- **Etiquetas no índice:** sombra, reflexo, brilho, névoa, lettering, fonte, pele, cabelo, recorte, fundo, produto, natal, pascoa, prompt, gerador...
- **Tamanho:** `indice.md` com até ~60 linhas. Passou disso, o professor junta as lições parecidas e mostra ao usuário o que juntou.
- **Técnica que deu certo em 2 KVs vira receita em script:** o professor escreve a proposta de função para `ferramentas/receitas.jsx` e a linha do [cardápio](ferramentas/cardapio.md), marcadas "não testado; primeiro teste no Codex".
- **Lição que atrapalhou:** se uma lição levou a erro num job, o professor propõe na aula a correção ou a exclusão. Só muda com o "ok" do usuário.
