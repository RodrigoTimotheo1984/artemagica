# Compara molde e exportação em números, sem abrir imagem (economia de tokens).
# Uso: powershell -File comparar-grade.ps1 -Molde <molde/aprovado.png> -Exportacao <exportacoes/x.png> [-Colunas 6] [-Linhas 4] [-Limite 12]
# Saída: por célula, brilho (0-255) do molde e da montagem, diferença de brilho e de cor (R,G,B).
# Células com |diferença| acima do limite saem marcadas com "<<". Brilho mais baixo na montagem = mais escuro que o molde.
param(
    [Parameter(Mandatory = $true)][string]$Molde,
    [Parameter(Mandatory = $true)][string]$Exportacao,
    [int]$Colunas = 6,
    [int]$Linhas = 4,
    [int]$Limite = 12
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# Reduz a imagem para Colunas x Linhas; cada pixel resultante é a média da célula.
function Reduzir([string]$caminho) {
    $img = [System.Drawing.Image]::FromFile((Resolve-Path $caminho))
    $passo = New-Object System.Drawing.Bitmap ($Colunas * 16), ($Linhas * 16)
    $g = [System.Drawing.Graphics]::FromImage($passo)
    $g.InterpolationMode = 'HighQualityBilinear'
    $g.DrawImage($img, 0, 0, $passo.Width, $passo.Height)
    $g.Dispose(); $img.Dispose()
    $cel = @{}
    for ($l = 0; $l -lt $Linhas; $l++) { for ($c = 0; $c -lt $Colunas; $c++) {
        $r = 0; $gg = 0; $b = 0
        for ($y = 0; $y -lt 16; $y++) { for ($x = 0; $x -lt 16; $x++) {
            $p = $passo.GetPixel($c * 16 + $x, $l * 16 + $y); $r += $p.R; $gg += $p.G; $b += $p.B } }
        $cel["$l,$c"] = @([math]::Round($r / 256), [math]::Round($gg / 256), [math]::Round($b / 256))
    } }
    $passo.Dispose()
    return $cel
}

function Brilho($rgb) { return [math]::Round(0.299 * $rgb[0] + 0.587 * $rgb[1] + 0.114 * $rgb[2]) }

$a = Reduzir $Molde
$b = Reduzir $Exportacao
$fora = 0
"Grade ${Colunas}x${Linhas} | limite $Limite | célula = linha,coluna a partir do canto superior esquerdo"
for ($l = 0; $l -lt $Linhas; $l++) { for ($c = 0; $c -lt $Colunas; $c++) {
    $m = $a["$l,$c"]; $e = $b["$l,$c"]
    $dB = (Brilho $e) - (Brilho $m)
    $dR = $e[0] - $m[0]; $dG = $e[1] - $m[1]; $dBl = $e[2] - $m[2]
    $pior = [math]::Max([math]::Abs($dB), [math]::Max([math]::Abs($dR), [math]::Max([math]::Abs($dG), [math]::Abs($dBl))))
    $marca = ''; if ($pior -gt $Limite) { $marca = '  <<'; $fora++ }
    "{0},{1}  brilho molde {2,3} montagem {3,3} (dif {4,4})  cor dif R{5,4} G{6,4} B{7,4}{8}" -f $l, $c, (Brilho $m), (Brilho $e), $dB, $dR, $dG, $dBl, $marca
} }
"Células fora do limite: $fora de $($Colunas * $Linhas)"
