# Chamada clara sobre fundo movimentado

**Quando usar:** texto claro (branco ou creme) sobre um fundo de cena cheio (loja, sala), e no molde a chamada "descola" do fundo com uma área mais escura ou mais lisa atrás dela e uma sombra suave nas letras.

**Passos** (números de um KV aprovado; px do molde × largura final ÷ largura do molde):
1. Ative a camada do fundo. `R.nuvem`: oval de cor atrás da chamada.
   - Cor: medir com `medir.ps1 cor` (campo **fundo**) na região da chamada, depois ajustar no olho. Exemplo: medido #2B4166 e final #003CAF.
   - Opacidade 85%; centro no centro da caixa da chamada; raios ~460×150; borda 90.
2. Texto com `R.textoMolde`, encaixado pela largura de cada linha.
3. `R.estilo` nas letras: sombra na cor escura do fundo (exemplo: #04204C), 65%, 120°, distância 4, tamanho 8. **Contorno só se o molde tiver.**

**Conferir:** `medir.ps1 recorte` na área da chamada; a `nitidez` perto de 0,9 e o `brilho` perto de 0.

**Origem:** KV de Natal, 3 voltas, aprovado (10/2026).
