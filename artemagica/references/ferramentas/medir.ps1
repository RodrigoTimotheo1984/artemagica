# Ferramentas de medida da artemagica: tiram números do molde e comparam uma área do molde com a mesma área da montagem.
# Rápido (C# compilado na hora, ~1 s) e sem abrir imagem. Lê PNG/JPG/BMP (WebP não: converta antes).
#
# Uso (sempre em px do MOLDE; a montagem é convertida pela proporção de largura):
#   powershell -File medir.ps1 texto   -Molde <png> -Regiao x,y,w,h [-Limiar 200]
#       acha as linhas de texto claro na região e imprime a caixa de cada uma (largura, altura, altura de maiúscula aproximada)
#   powershell -File medir.ps1 cor     -Molde <png> -Regiao x,y,w,h
#       cor média, cor das sombras (10% mais escuros) e das luzes (10% mais claros) da região
#   powershell -File medir.ps1 recorte -Molde <png> -Montagem <png> -Regiao x,y,w,h -Saida <png> [-Rotulo v03-volta2]
#       folha: molde | montagem | diferença (realçada) da mesma área, no mesmo tamanho, e a NOTA DE DISTÂNCIA
#   powershell -File medir.ps1 mascara -Molde <png> -Regiao x,y,w,h -Saida <png> [-Limiar 200]
#       salva o que a ferramenta entende como texto (branco), para conferir o limiar
#   powershell -File medir.ps1 fonte   -Molde <png> -Regiao x,y,w,h -Candidatos <pasta> [-Saida <folha.png>] [-Limiar 200]
#       compara a máscara do texto do molde com cada PNG da pasta (saída da prova-fontes.jsx) e ordena da mais parecida para a menos
#
# NOTA DE DISTÂNCIA (recorte): 0 = idêntico. Serve para comparar voltas: caiu = melhorou.
#   texto       quanto o desenho das letras claras coincide com o molde (100 = idêntico; ignora o fundo)
#   dif_media   diferença média de cor (0-255)
#   brilho      montagem - molde (negativo = montagem mais escura)
#   quente      (R-B) montagem - molde (positivo = montagem mais quente)
#   nitidez     detalhe da montagem / detalhe do molde (1,00 = igual; >1 = montagem mais nítida, falta névoa/desfoque; <1 = mais borrada)
param(
    [Parameter(Mandatory = $true, Position = 0)][ValidateSet('texto', 'cor', 'recorte', 'fonte', 'mascara')][string]$Modo,
    [Parameter(Mandatory = $true)][string]$Molde,
    [string]$Montagem,
    [Parameter(Mandatory = $true)][string]$Regiao,
    [string]$Saida,
    [string]$Candidatos,
    [string]$Rotulo = '',
    [int]$Limiar = 200
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
Add-Type -AssemblyName System.Drawing
if (-not ('Medir' -as [type])) {
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging; using System.Collections.Generic; using System.Runtime.InteropServices;
public static class Medir {
    // Lê a região (x,y,w,h) e devolve RGB em byte[h,w,3], já redimensionada para outW x outH se pedido.
    public static byte[,,] Ler(string path, int x, int y, int w, int h, int outW, int outH) {
        using (var src = new Bitmap(path)) {
            if (outW <= 0) { outW = w; outH = h; }
            using (var dst = new Bitmap(outW, outH, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(dst)) {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                g.DrawImage(src, new Rectangle(0, 0, outW, outH), new Rectangle(x, y, w, h), GraphicsUnit.Pixel);
                var d = dst.LockBits(new Rectangle(0, 0, outW, outH), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
                var buf = new byte[d.Stride * outH]; Marshal.Copy(d.Scan0, buf, 0, buf.Length); dst.UnlockBits(d);
                var r = new byte[outH, outW, 3];
                for (int j = 0; j < outH; j++) for (int i = 0; i < outW; i++) {
                    int o = j * d.Stride + i * 3; r[j, i, 0] = buf[o + 2]; r[j, i, 1] = buf[o + 1]; r[j, i, 2] = buf[o]; }
                return r;
            }
        }
    }
    public static int[] Tamanho(string path) { using (var b = new Bitmap(path)) return new[] { b.Width, b.Height }; }
    // Texto claro: brilho alto e pouca saturação.
    public static bool[,] Mascara(byte[,,] a, int limiar) {
        int h = a.GetLength(0), w = a.GetLength(1); var m = new bool[h, w];
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) {
            int r = a[j, i, 0], g = a[j, i, 1], b = a[j, i, 2];
            int mx = Math.Max(r, Math.Max(g, b)), mn = Math.Min(r, Math.Min(g, b));
            m[j, i] = (0.299 * r + 0.587 * g + 0.114 * b) >= limiar && (mx - mn) < 60; }
        return m;
    }
    // Linhas de texto: faixas de linhas com pixels de máscara; devolve [y0,y1,x0,x1,pixels] por linha.
    public static List<int[]> Linhas(bool[,] m) {
        int h = m.GetLength(0), w = m.GetLength(1); var cont = new int[h];
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) if (m[j, i]) cont[j]++;
        int minPx = Math.Max(2, w / 300); var res = new List<int[]>(); int ini = -1, vazio = 0;
        for (int j = 0; j <= h; j++) {
            bool tem = j < h && cont[j] >= minPx;
            if (tem) { if (ini < 0) ini = j; vazio = 0; }
            else if (ini >= 0) { vazio++; if (vazio >= 2 || j == h) { int fim = j - vazio; if (fim - ini >= 6) res.Add(new[] { ini, fim, 0, 0, 0 }); ini = -1; vazio = 0; } }
        }
        // linhas encostadas (acento de uma tocando a outra): divide no vale de densidade do meio da faixa
        for (int k = 0; k < res.Count; k++) {
            int a0 = res[k][0], a1 = res[k][1], pico = 0; for (int j = a0; j <= a1; j++) pico = Math.Max(pico, cont[j]);
            int ini2 = -1, melhorIni = -1, melhorLen = 0;
            for (int j = a0 + (a1 - a0) / 5; j <= a1 - (a1 - a0) / 5; j++) {
                if (cont[j] < pico * 0.12) { if (ini2 < 0) ini2 = j; if (j - ini2 + 1 > melhorLen) { melhorLen = j - ini2 + 1; melhorIni = ini2; } } else ini2 = -1; }
            if (melhorLen >= 1 && melhorIni + melhorLen / 2 - a0 >= (a1 - a0) * 0.35 && a1 - (melhorIni + melhorLen / 2) >= (a1 - a0) * 0.35) { int corte = melhorIni + melhorLen / 2; res.Insert(k + 1, new[] { corte + 1, a1, 0, 0, 0 }); res[k][1] = corte; k--; }
        }
        foreach (var L in res) { int x0 = w, x1 = -1, n = 0;
            for (int j = L[0]; j <= L[1]; j++) for (int i = 0; i < w; i++) if (m[j, i]) { if (i < x0) x0 = i; if (i > x1) x1 = i; n++; }
            // aparo: pedaço claro separado do texto por um vão grande (luz, reflexo) sai; espaço entre palavras é vão pequeno
            var col = new int[w]; for (int j = L[0]; j <= L[1]; j++) for (int i = x0; i <= x1; i++) if (m[j, i]) col[i]++;
            int vaoMax = Math.Max(6, (L[1] - L[0]) * 45 / 100); int bIni = -1, bN = 0, melhorI = x0, melhorF = x1, melhorN = -1, ultimo = -1;
            for (int i = x0; i <= x1 + 1; i++) {
                bool tem = i <= x1 && col[i] > 0;
                if (tem) { if (bIni < 0 || i - ultimo > vaoMax) { if (bIni >= 0 && bN > melhorN) { melhorN = bN; melhorI = bIni; melhorF = ultimo; } bIni = i; bN = 0; } bN += col[i]; ultimo = i; }
                if (i == x1 + 1 && bIni >= 0 && bN > melhorN) { melhorN = bN; melhorI = bIni; melhorF = ultimo; } }
            x0 = melhorI; x1 = melhorF; n = melhorN;
            // refaz o topo e a base só com o que ficou dentro da largura do texto
            int y0 = -1, y1 = -1; for (int j = L[0]; j <= L[1]; j++) { int q = 0; for (int i = x0; i <= x1; i++) if (m[j, i]) q++; if (q >= Math.Max(minPx, (x1 - x0) / 60)) { if (y0 < 0) y0 = j; y1 = j; } }
            if (y0 >= 0) { L[0] = y0; L[1] = y1; }
            L[2] = x0; L[3] = x1; L[4] = n; }
        // descarta luzes soltas e pontinhos: linha de texto tem largura e pixels de verdade
        res.RemoveAll(L => (L[3] - L[2]) < w / 8 || L[4] < (L[3] - L[2]) * 2);
        // acento solto em cima de uma linha (faixa baixa e curta logo acima) é juntado à linha de baixo
        for (int k = res.Count - 2; k >= 0; k--) if (res[k][1] - res[k][0] < (res[k + 1][1] - res[k + 1][0]) / 3 && res[k + 1][0] - res[k][1] < 8) {
            res[k + 1][0] = res[k][0]; res[k + 1][2] = Math.Min(res[k][2], res[k + 1][2]); res[k + 1][3] = Math.Max(res[k][3], res[k + 1][3]); res.RemoveAt(k); }
        return res;
    }
    // Altura de maiúscula/x aproximada: faixa de linhas com densidade acima de 35% do pico (ignora acentos e descendentes).
    public static int Corpo(bool[,] m, int[] L) {
        int pico = 0; var c = new int[L[1] - L[0] + 1];
        for (int j = L[0]; j <= L[1]; j++) { for (int i = L[2]; i <= L[3]; i++) if (m[j, i]) c[j - L[0]]++; pico = Math.Max(pico, c[j - L[0]]); }
        int n = 0; foreach (var v in c) if (v >= pico * 0.35) n++; return n;
    }
    // Cor média do que NÃO é texto claro: a cor certa para a nuvem/névoa atrás de uma chamada.
    public static double[] CorFundo(byte[,,] a, int limiar) {
        var m = Mascara(a, limiar); int h = a.GetLength(0), w = a.GetLength(1); double r = 0, g = 0, b = 0; int n = 0;
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) if (!m[j, i]) { r += a[j, i, 0]; g += a[j, i, 1]; b += a[j, i, 2]; n++; }
        return new[] { r / Math.Max(n, 1), g / Math.Max(n, 1), b / Math.Max(n, 1) };
    }
    public static double[] Cor(byte[,,] a) {
        int h = a.GetLength(0), w = a.GetLength(1), n = h * w; var lum = new double[n]; double r = 0, g = 0, b = 0; int k = 0;
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) { r += a[j, i, 0]; g += a[j, i, 1]; b += a[j, i, 2]; lum[k++] = 0.299 * a[j, i, 0] + 0.587 * a[j, i, 1] + 0.114 * a[j, i, 2]; }
        var ord = (double[])lum.Clone(); Array.Sort(ord); double lo = ord[n / 10], hi = ord[n - 1 - n / 10];
        double[] s = new double[3], l = new double[3]; int ns = 0, nl = 0; k = 0;
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++, k++) {
            if (lum[k] <= lo) { for (int c = 0; c < 3; c++) s[c] += a[j, i, c]; ns++; }
            if (lum[k] >= hi) { for (int c = 0; c < 3; c++) l[c] += a[j, i, c]; nl++; } }
        return new[] { r / n, g / n, b / n, s[0] / ns, s[1] / ns, s[2] / ns, l[0] / nl, l[1] / nl, l[2] / nl };
    }
    static double Detalhe(byte[,,] a) {
        int h = a.GetLength(0), w = a.GetLength(1); double t = 0;
        for (int j = 1; j < h - 1; j++) for (int i = 1; i < w - 1; i++) {
            double c = a[j, i, 1], gx = a[j, i + 1, 1] - a[j, i - 1, 1], gy = a[j + 1, i, 1] - a[j - 1, i, 1]; t += Math.Abs(gx) + Math.Abs(gy); }
        return t / ((h - 2) * (w - 2));
    }
    // Nota de distância + folha molde | montagem | diferença.
    public static double[] Comparar(byte[,,] a, byte[,,] b, string saida) {
        int h = a.GetLength(0), w = a.GetLength(1); double dif = 0, la = 0, lb = 0, qa = 0, qb = 0;
        using (var bmp = new Bitmap(w * 3 + 40, h, PixelFormat.Format24bppRgb)) {
            using (var g = Graphics.FromImage(bmp)) g.Clear(Color.White);
            for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) {
                double d = 0; for (int c = 0; c < 3; c++) d += Math.Abs(a[j, i, c] - b[j, i, c]); d /= 3; dif += d;
                la += 0.299 * a[j, i, 0] + 0.587 * a[j, i, 1] + 0.114 * a[j, i, 2]; lb += 0.299 * b[j, i, 0] + 0.587 * b[j, i, 1] + 0.114 * b[j, i, 2];
                qa += a[j, i, 0] - a[j, i, 2]; qb += b[j, i, 0] - b[j, i, 2];
                bmp.SetPixel(i, j, Color.FromArgb(a[j, i, 0], a[j, i, 1], a[j, i, 2]));
                bmp.SetPixel(w + 20 + i, j, Color.FromArgb(b[j, i, 0], b[j, i, 1], b[j, i, 2]));
                int v = (int)Math.Min(255, d * 2); bmp.SetPixel(2 * w + 40 + i, j, Color.FromArgb(v, v / 3, v / 3)); }
            if (saida != null && saida.Length > 0) bmp.Save(saida, ImageFormat.Png);
        }
        int n = h * w; return new[] { dif / n, (lb - la) / n, (qb - qa) / n, Detalhe(b) / Math.Max(Detalhe(a), 0.001) };
    }
    public static void SalvarMascara(bool[,] m, string saida) {
        int h = m.GetLength(0), w = m.GetLength(1);
        using (var b = new Bitmap(w, h, PixelFormat.Format24bppRgb)) {
            for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) b.SetPixel(i, j, m[j, i] ? Color.White : Color.Black);
            b.Save(saida, ImageFormat.Png); }
    }
    public static double IoU(bool[,] a, bool[,] b) {
        int h = a.GetLength(0), w = a.GetLength(1), u = 0, x = 0;
        for (int j = 0; j < h; j++) for (int i = 0; i < w; i++) { if (a[j, i] || b[j, i]) u++; if (a[j, i] && b[j, i]) x++; }
        return u == 0 ? 0 : (double)x / u;
    }
}
'@
}
$r = $Regiao -split ',' | ForEach-Object { [int]$_ }
$x, $y, $w, $h = $r
$Molde = (Resolve-Path $Molde).Path

switch ($Modo) {
    'texto' {
        $a = [Medir]::Ler($Molde, $x, $y, $w, $h, 0, 0)
        $m = [Medir]::Mascara($a, $Limiar)
        $L = [Medir]::Linhas($m)
        "Texto claro na região $Regiao (limiar $Limiar): $($L.Count) linha(s). Caixas em px do molde."
        $k = 1
        foreach ($ln in $L) {
            $corpo = [Medir]::Corpo($m, $ln)
            "  linha {0}: x {1}..{2}  y {3}..{4}  largura {5}  altura {6}  corpo(maiúscula/x) ~{7}" -f $k, ($x + $ln[2]), ($x + $ln[3]), ($y + $ln[0]), ($y + $ln[1]), ($ln[3] - $ln[2] + 1), ($ln[1] - $ln[0] + 1), $corpo
            $k++
        }
        $topos = @(); foreach ($ln in $L) { $topos += $y + $ln[0] }
        if ($topos.Count -gt 1) { $e = for ($i = 1; $i -lt $topos.Count; $i++) { $topos[$i] - $topos[$i - 1] }; "  entrelinha (topo a topo): " + ($e -join ', ') }
    }
    'cor' {
        $a = [Medir]::Ler($Molde, $x, $y, $w, $h, 0, 0)
        $c = [Medir]::Cor($a)
        function hex($r, $g, $b) { '#{0:X2}{1:X2}{2:X2}' -f [int]$r, [int]$g, [int]$b }
        "Cor na região ${Regiao}:"
        "  média     " + (hex $c[0] $c[1] $c[2])
        "  sombras   " + (hex $c[3] $c[4] $c[5]) + "  (10% mais escuros: cor de sombra/névoa escura)"
        "  luzes     " + (hex $c[6] $c[7] $c[8]) + "  (10% mais claros: cor de brilho/névoa clara)"
        $f = [Medir]::CorFundo($a, $Limiar)
        "  fundo     " + (hex $f[0] $f[1] $f[2]) + "  (média sem o texto claro: cor para nuvem/névoa atrás de uma chamada)"
    }
    'recorte' {
        if (-not $Montagem -or -not $Saida) { throw 'recorte precisa de -Montagem e -Saida' }
        $Montagem = (Resolve-Path $Montagem).Path
        $tm = [Medir]::Tamanho($Molde); $te = [Medir]::Tamanho($Montagem)
        $f = $te[0] / $tm[0]
        # compara no tamanho da montagem (mais detalhe), com o molde ampliado para o mesmo tamanho
        $ow = [int][math]::Round($w * $f); $oh = [int][math]::Round($h * $f)
        $a = [Medir]::Ler($Molde, $x, $y, $w, $h, $ow, $oh)
        $b = [Medir]::Ler($Montagem, [int][math]::Round($x * $f), [int][math]::Round($y * $f), $ow, $oh, $ow, $oh)
        $n = [Medir]::Comparar($a, $b, $Saida)
        $txt = [math]::Round([Medir]::IoU([Medir]::Mascara($a, $Limiar), [Medir]::Mascara($b, $Limiar)) * 100, 1)
        "NOTA {0} | texto {7}% | dif_media {1:N1} | brilho {2:+0.0;-0.0} | quente {3:+0.0;-0.0} | nitidez {4:N2} | regiao {5} | folha {6}" -f $Rotulo, $n[0], $n[1], $n[2], $n[3], $Regiao, $Saida, $txt
    }
    'mascara' {
        if (-not $Saida) { throw 'mascara precisa de -Saida' }
        $a = [Medir]::Ler($Molde, $x, $y, $w, $h, 0, 0)
        [Medir]::SalvarMascara([Medir]::Mascara($a, $Limiar), $Saida)
        "Máscara do texto claro (limiar $Limiar) salva em ${Saida}: confira se só as letras ficaram brancas."
    }
    'fonte' {
        if (-not $Candidatos) { throw 'fonte precisa de -Candidatos <pasta>' }
        $a = [Medir]::Ler($Molde, $x, $y, $w, $h, 0, 0)
        $m = [Medir]::Mascara($a, $Limiar)
        $res = foreach ($p in Get-ChildItem $Candidatos -Filter *.png) {
            $b = [Medir]::Ler($p.FullName, 0, 0, ([Medir]::Tamanho($p.FullName))[0], ([Medir]::Tamanho($p.FullName))[1], $w, $h)
            $mb = [Medir]::Mascara($b, 128)
            [pscustomobject]@{ Fonte = $p.BaseName; Coincide = [math]::Round([Medir]::IoU($m, $mb) * 100, 1) }
        }
        "Coincidência do desenho das letras com o molde (100 = idêntico). O número só separa as candidatas;"
        "quem decide é o olho na folha (molde em cima, as 4 primeiras embaixo)."
        $ord = @($res | Sort-Object Coincide -Descending)
        $ord | ForEach-Object { "  {0,5}%  {1}" -f $_.Coincide, $_.Fonte }
        if ($Saida) {
            $top = @($ord | Select-Object -First 4)
            $folha = New-Object System.Drawing.Bitmap $w, (($h + 24) * ($top.Count + 1))
            $g = [System.Drawing.Graphics]::FromImage($folha); $g.Clear([System.Drawing.Color]::White)
            $fnt = New-Object System.Drawing.Font 'Arial', 11
            $src = [System.Drawing.Image]::FromFile($Molde)
            $g.DrawString('MOLDE', $fnt, [System.Drawing.Brushes]::Black, 4, 4)
            $g.DrawImage($src, (New-Object System.Drawing.Rectangle 0, 22, $w, $h), (New-Object System.Drawing.Rectangle $x, $y, $w, $h), [System.Drawing.GraphicsUnit]::Pixel); $src.Dispose()
            for ($i = 0; $i -lt $top.Count; $i++) {
                $yy = ($i + 1) * ($h + 24)
                $g.DrawString(('{0}. {1}  ({2}%)' -f ($i + 1), $top[$i].Fonte, $top[$i].Coincide), $fnt, [System.Drawing.Brushes]::Black, 4, $yy + 4)
                $c = [System.Drawing.Image]::FromFile((Join-Path $Candidatos ($top[$i].Fonte + '.png')))
                $g.DrawImage($c, 0, $yy + 22, $w, $h); $c.Dispose()
            }
            $g.Dispose(); $folha.Save($Saida); $folha.Dispose()
            "Folha: $Saida"
        }
    }
}
