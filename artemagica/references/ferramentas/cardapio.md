# Cardápio de receitas (artemagica)

Leia na montagem. Cada receita está em [receitas.jsx](receitas.jsx) e foi testada no Photoshop 2026 em 29/10/2026. Tudo fica editável: camada de cor com máscara, estilo de camada ou filtro inteligente. Para usar no `montar.jsx` do job (troque `<skill>` pelo caminho real da pasta da skill, com barras `/`):

```js
#include "<skill>/references/ferramentas/receitas.jsx"
```

A camada nova nasce logo acima da camada ativa: antes de chamar a receita, ative a camada que deve ficar embaixo.

## Receitas

| Receita | O que faz | Quando usar (o que a referência mostra) | De onde vêm os números |
|---|---|---|---|
| `R.textoMolde` | Linha de texto editável encaixada na caixa da referência, pela largura (padrão) ou pela altura | Toda chamada ou texto que exista na referência | `medir.ps1 texto` (caixas) + `prova-fontes` (fonte) |
| `R.estilo` | Sombra suave, brilho externo e interno, contorno: um estilo completo | Sombra ou brilho nas letras. **Contorno só se a referência tiver** | Cor: `medir.ps1 cor` (sombras/fundo). Tamanho: voltas |
| `R.nuvem` | Mancha oval de cor com borda muito suave | Fundo mais escuro ou mais liso atrás de uma chamada; foco de luz | Cor: `medir.ps1 cor` → **fundo**. Centro e tamanho: caixa do texto + folga |
| `R.nevoaProfundidade` | Degradê de cor que some de cima para baixo (ou o contrário) | Fundo distante mais claro, quente e sem contraste ("ar" da cena) | Cor: `medir.ps1 cor` → luzes da área do fundo. Força: `nitidez` do recorte |
| `R.sombraContato` | Oval escura e achatada, em Multiplicar | Objeto ou pessoa apoiados (carrinho, produto, pés) | Cor: sombras da referência perto do apoio |
| `R.casarCor` | Tinge um elemento com a cor da cena (camada presa a ele) | Pessoa ou objeto gerado que chegou com outra cor e "parece colado" | Cor: `medir.ps1 cor` da área da referência onde o elemento está |
| `R.halo` | Brilho suave em volta de um objeto | Selo, luz ou produto com brilho em volta na referência | Cor: luzes da referência perto do objeto |
| `R.desfocar` | Desfoque gaussiano como filtro inteligente | Elemento que na referência está fora de foco | `nitidez` do recorte acima de 1 |
| `R.vinheta` | Bordas mais escuras (sempre no topo) | Molde com cantos mais escuros | Força: brilho dos cantos (grade) |
| `R.exportarProva` | Exporta o PNG para conferir | Toda volta | — |

## Ferramentas de medida ([medir.ps1](medir.ps1), ~1 s, sem abrir imagem)

| Comando | Para quê |
|---|---|
| `texto -Regiao` | Caixa de cada linha de texto claro da referência: largura, altura e entrelinha |
| `mascara -Regiao -Saida` | Mostra o que a ferramenta entendeu como texto. Se uma luz entrar, aperte a região |
| `cor -Regiao` | Cor média, das sombras, das luzes e do **fundo sem o texto** |
| `recorte -Regiao -Montagem -Saida` | Folha referência \| montagem \| diferença da mesma área, e a **NOTA**: `texto`% (desenho das letras), `dif_media`, `brilho`, `quente`, `nitidez` |
| `fonte -Candidatos -Saida` | Ordena as fontes da `prova-fontes.jsx` e faz a folha com a referência e as 4 primeiras |

As regiões são sempre em **px da referência**.

## Registro de uso

Os números que funcionaram em cada job ficam no cérebro da skill ([../../cerebro/tecnicas/](../../cerebro/tecnicas/) e [historico.md](../../cerebro/historico.md)), escritos pelo professor depois do aceite do usuário. Consulte antes de escolher os números de um job novo.
