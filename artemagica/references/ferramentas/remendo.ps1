# Remendo: copia so uma area da imagem editada para cima do original, com borda suave.
# O resto continua com os pixels do original (sem as manchas que cada edicao acumula).
# Uso: powershell -File remendo.ps1 -Original kv-a-v01.png -Editada kv-a-v02-edicao.png -X 100 -Y 900 -Largura 1200 -Altura 300 -Saida kv-a-v02.png [-Suave 24]
# X, Y, Largura e Altura em pixels do original. Se a editada tiver outro tamanho, ela e ajustada ao do original.
param(
  [Parameter(Mandatory=$true)][string]$Original,
  [Parameter(Mandatory=$true)][string]$Editada,
  [Parameter(Mandatory=$true)][int]$X,
  [Parameter(Mandatory=$true)][int]$Y,
  [Parameter(Mandatory=$true)][int]$Largura,
  [Parameter(Mandatory=$true)][int]$Altura,
  [Parameter(Mandatory=$true)][string]$Saida,
  [int]$Suave = 24
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
if (Test-Path -LiteralPath $Saida) { throw "Ja existe: $Saida (use nova vNN)" }
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging; using System.Runtime.InteropServices;
public static class Remendo {
  public static void Aplicar(Bitmap orig, Bitmap ed, int x0, int y0, int w, int h, int suave) {
    var r = new Rectangle(0, 0, orig.Width, orig.Height);
    var a = orig.LockBits(r, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
    var b = ed.LockBits(r, ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
    int n = a.Stride * orig.Height; var pa = new byte[n]; var pb = new byte[n];
    Marshal.Copy(a.Scan0, pa, 0, n); Marshal.Copy(b.Scan0, pb, 0, n);
    int x1 = Math.Max(0, x0 - suave), y1 = Math.Max(0, y0 - suave);
    int x2 = Math.Min(orig.Width, x0 + w + suave), y2 = Math.Min(orig.Height, y0 + h + suave);
    for (int y = y1; y < y2; y++) for (int x = x1; x < x2; x++) {
      int dx = Math.Max(Math.Max(x0 - x, x - (x0 + w - 1)), 0), dy = Math.Max(Math.Max(y0 - y, y - (y0 + h - 1)), 0);
      double d = Math.Sqrt(dx * dx + dy * dy);
      double t = suave <= 0 ? (d == 0 ? 1 : 0) : Math.Max(0, 1 - d / suave);
      if (t <= 0) continue;
      int i = y * a.Stride + x * 4;
      for (int c = 0; c < 4; c++) pa[i + c] = (byte)Math.Round(pa[i + c] * (1 - t) + pb[i + c] * t);
    }
    Marshal.Copy(pa, 0, a.Scan0, n); orig.UnlockBits(a); ed.UnlockBits(b);
  }
}
'@
$orig = New-Object System.Drawing.Bitmap ((Resolve-Path -LiteralPath $Original).Path)
$base = New-Object System.Drawing.Bitmap $orig.Width, $orig.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($base); $g.DrawImage($orig, 0, 0, $orig.Width, $orig.Height); $g.Dispose()
$edImg = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $Editada).Path)
$aviso = ''
if ($edImg.Width -ne $orig.Width -or $edImg.Height -ne $orig.Height) { $aviso = "AVISO: editada era $($edImg.Width)x$($edImg.Height); ajustada a $($orig.Width)x$($orig.Height). Confira o alinhamento da borda a 100%." }
$ed = New-Object System.Drawing.Bitmap $orig.Width, $orig.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($ed)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($edImg, 0, 0, $orig.Width, $orig.Height); $g.Dispose()
[Remendo]::Aplicar($base, $ed, $X, $Y, $Largura, $Altura, $Suave)
$pasta = Split-Path -Parent $Saida
if ($pasta -and -not (Test-Path -LiteralPath $pasta)) { New-Item -ItemType Directory -Path $pasta | Out-Null }
$base.Save($Saida, [System.Drawing.Imaging.ImageFormat]::Png)
$base.Dispose(); $ed.Dispose(); $edImg.Dispose(); $orig.Dispose()
"Salvo: $Saida | remendo em ($X,$Y) ${Largura}x$Altura, borda suave $Suave px"
if ($aviso) { $aviso }
