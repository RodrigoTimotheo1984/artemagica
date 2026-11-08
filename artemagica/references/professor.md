# Professor e cérebro (artemagica)

A skill aprende a cada KV. O que aprende fica no **cérebro**, `cerebro/`, dentro da pasta da skill: arquivos de texto que o Codex lê e escreve e que o usuário consegue abrir. Lição errada se corrige apagando a linha.

## O que tem no cérebro

| Arquivo | Guarda | Quem lê |
|---|---|---|
| `indice.md` | Uma linha por lição ou técnica, com etiquetas e o caminho. **Lido no começo de todo job** | todos |
| `licoes.md` | Lições gerais: o que funciona, o que o usuário recusa e por quê, decisões de processo | principal, olheiro |
| `olho.md` | Checklist do olheiro: o que já passou batido ou mais apareceu como falta. Ordem = o mais esquecido primeiro | olheiro |
| `tecnicas/<nome>.md` | Uma técnica de Photoshop por arquivo: passo a passo com números, quando usar, de quais jobs veio; antes/depois em `tecnicas/img/` | técnico, montador |
| `prompts.md` | Prompts de geração que deram certo e errado, por tipo (layout, fundo, personagem, objeto, lettering, molde final), e o tamanho real de cada gerador | principal |
| `historico.md` | Uma linha por KV: data, job, nota final, voltas, tempo, gerações, créditos, o que o usuário disse | principal |

## A aula (depois do aceite do usuário)

Só depois do aceite explícito da peça. Um job não aceito não ensina "o que funciona", só "o que não funcionou", e assim é marcado.

1. O professor (subagente) lê o que o job deixou:
   - `revisao/medidas/` (a régua de cada volta) e `revisao/olheiro-final-*.md`;
   - a conversa com o técnico: o que funcionou e o que **não** funcionou;
   - `mudancas.md` e o resultado dos testes do designer e de formato;
   - `revisao/geracoes.md` (prompts aprovados e recusados, com o motivo);
   - o que o usuário disse na conversa (a principal resume em até 10 linhas no pedido).
2. Ele escreve uma **proposta de aula** em `revisao/aula.md`:
   - **no máximo ~5 lições**, as que mais vão ajudar no próximo KV;
   - **técnicas novas:** cada pedaço que levou 2 voltas ou mais e chegou nos 95 vira `tecnicas/<nome>.md`, se não existir parecida; se existir, a técnica é melhorada com os números novos;
   - itens para o `olho.md`: o que a régua não pegou e só o olho achou (do olheiro final ou do usuário);
   - prompts para o `prompts.md`: os aprovados de primeira e os que falharam, com o porquê;
   - a linha do `historico.md`.
3. A conversa principal mostra a aula ao usuário **em linguagem simples**: "aprendi isto: …". Ele aprova, corta ou corrige.
4. Com o "ok", o professor escreve no cérebro e atualiza o `indice.md`.

## Regras do cérebro

- **Geral, nunca preso a um job.** Escreva "objeto sobre superfície brilhante tem reflexo invertido de ~20–30%", e não "o selo do Natal tem reflexo". O job entra só como origem: "(KV de Natal, 11/2026)".
- **Números e condição:** toda lição diz quando vale e com quais números de partida.
- **Sem repetição:** antes de escrever, procure a lição parecida e melhore ela.
- **Etiquetas no índice:** sombra, reflexo, brilho, névoa, lettering, fonte, pele, cabelo, recorte, fundo, produto, natal, pascoa, prompt, gerador...
- **Tamanho:** `indice.md` com até ~60 linhas. Passou disso, o professor junta as lições parecidas e mostra ao usuário o que juntou.
- **Técnica que deu certo em 2 KVs vira receita em script:** o professor escreve a proposta de função para `ferramentas/receitas.jsx` e a linha do [cardápio](ferramentas/cardapio.md), marcadas "não testado; primeiro teste no Codex". O montador testa no próximo job; funcionou, fica.
- **Lição que atrapalhou:** se uma lição levou a erro num job, o professor propõe na aula a correção ou a exclusão. Só muda com o "ok" do usuário.
