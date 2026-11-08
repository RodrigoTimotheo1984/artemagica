# Régua da artemagica: semelhança estrutural (SSIM em blocos 8x8 por canal RGB) entre o alvo e a montagem,
# no quadro inteiro e por pedaço. Converte a cor de cada arquivo para sRGB pelo perfil ICC embutido.
# Fórmula usada num teste real (11/2026), generalizada.
# NÃO TESTADO nesta versão: primeiro teste no Codex. Precisa de Pillow e NumPy.
#
# Uso (a partir da pasta do job):
#   python <skill>/references/ferramentas/medir-semelhanca.py --molde <alvo vigente> --montagem revisao/provas/v03.png
#          [--pecas revisao/medidas/pecas.json] [--folhas revisao/medidas/v03] [--saida revisao/medidas/v03.txt] [--meta 95]
#
#   --pecas   JSON em px do ALVO (direita e base exclusivas). Cada pedaço é uma caixa ou uma caixa com meta própria:
#               {"selo": [20,18,800,684], "chamada": {"caixa": [810,58,1490,200], "meta": 90}}
#             "total" é reservado (o quadro inteiro). Sem --pecas, mede só o total.
#   --folhas  pasta: salva, por pedaço, alvo | montagem | diferença (ampliada 2x; preto = igual) para olhar.
#   --saida   grava a mesma saída (com os avisos) num arquivo, além de imprimir.
#   A montagem é ajustada ao tamanho do alvo (Lanczos) só se a proporção bater (até 1%).
#   Exporte PNG ou TIFF com perfil; PSD não.
#   INCONCLUSIVO = a nota não vale (perfil que não converteu, proporção diferente, caixa inválida).
#   A régua mede a caixa inteira, inclusive o fundo entre as letras. Aponta onde olhar; quem decide é o olho.
import argparse
import io
import json
import os
import sys

import numpy as np
from PIL import Image, ImageChops, ImageCms

SRGB = ImageCms.createProfile('sRGB')
linhas = []
inconclusivo = []


def dizer(texto):
    print(texto)
    linhas.append(texto)


def ler(caminho):
    nome = os.path.basename(caminho)
    im = Image.open(caminho)
    icc = im.info.get('icc_profile')
    if im.mode not in ('RGB', 'CMYK'):
        im = im.convert('RGB')
    if icc:
        try:
            im = ImageCms.profileToProfile(im, ImageCms.ImageCmsProfile(io.BytesIO(icc)), SRGB, outputMode='RGB')
        except (ImageCms.PyCMSError, OSError):
            inconclusivo.append(f'perfil de cor de {nome} não converteu')
            im = im.convert('RGB')
    else:
        dizer(f'AVISO: {nome} sem perfil de cor; tratado como sRGB. Só vale se a origem for sRGB.')
        im = im.convert('RGB')
    return im


def nota(a, b):
    x = np.asarray(a, dtype='float64')
    y = np.asarray(b, dtype='float64')
    h, w = x.shape[0] // 8 * 8, x.shape[1] // 8 * 8
    if h == 0 or w == 0:
        return None
    blocos = lambda z: z[:h, :w].reshape(h // 8, 8, w // 8, 8, 3)
    x, y = blocos(x), blocos(y)
    m, n = x.mean((1, 3)), y.mean((1, 3))
    v = (x * x).mean((1, 3)) - m * m
    u = (y * y).mean((1, 3)) - n * n
    c = (x * y).mean((1, 3)) - m * n
    s = (2 * m * n + 6.5025) * (2 * c + 58.5225) / ((m * m + n * n + 6.5025) * (v + u + 58.5225))
    return float(s.mean()) * 100


def folha(a, b, destino):
    dif = ImageChops.difference(a, b).point(lambda p: min(255, p * 4))
    w, h = a.size
    f = Image.new('RGB', (w * 3 + 20, h), (128, 128, 128))
    for i, im in enumerate((a, b, dif)):
        f.paste(im, (i * (w + 10), 0))
    f.resize((f.width * 2, f.height * 2), Image.Resampling.LANCZOS).save(destino)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--molde', required=True)
    p.add_argument('--montagem', required=True)
    p.add_argument('--pecas')
    p.add_argument('--folhas')
    p.add_argument('--saida')
    p.add_argument('--meta', type=float, default=95)
    a = p.parse_args()

    alvo = ler(a.molde)
    mont = ler(a.montagem)
    W, H = alvo.size
    w, h = mont.size
    if abs((w / h) / (W / H) - 1) > 0.01:
        inconclusivo.append(f'proporção diferente: alvo {W}x{H}, montagem {w}x{h}')
    elif (w, h) != (W, H):
        mont = mont.resize((W, H), Image.Resampling.LANCZOS)

    pecas = [('total', [0, 0, W, H], a.meta)]
    if a.pecas:
        with open(a.pecas, encoding='utf-8') as f:
            for nome, val in json.load(f).items():
                if nome == 'total':
                    inconclusivo.append('"total" é reservado no pecas.json; renomeie a caixa')
                    continue
                caixa, meta = (val['caixa'], val.get('meta', a.meta)) if isinstance(val, dict) else (val, a.meta)
                pecas.append((nome, caixa, meta))
    if a.folhas:
        os.makedirs(a.folhas, exist_ok=True)

    dizer(f'alvo {os.path.basename(a.molde)} {W}x{H} | montagem {os.path.basename(a.montagem)} {w}x{h}')
    abaixo = []
    if not inconclusivo:
        for nome, (l, t, r, d), meta in pecas:
            if l < 0 or t < 0 or r > W or d > H or r - l < 8 or d - t < 8:
                inconclusivo.append(f'caixa inválida em "{nome}": {[l, t, r, d]}')
                continue
            ca, cb = alvo.crop((l, t, r, d)), mont.crop((l, t, r, d))
            n = nota(ca, cb)
            ok = n >= meta
            if not ok:
                abaixo.append(nome)
            dizer(f'{nome:<20} {n:6.2f}  meta {meta:g}  {"ok" if ok else "ABAIXO"}')
            if a.folhas and nome != 'total':
                folha(ca, cb, os.path.join(a.folhas, f'{nome}.png'))

    for motivo in inconclusivo:
        dizer(f'INCONCLUSIVO: {motivo}')
    if inconclusivo:
        dizer('RESULTADO: INCONCLUSIVO (a nota não vale)')
    else:
        dizer('RESULTADO: ' + ('ok' if not abaixo else 'ABAIXO em ' + ', '.join(abaixo)))
    if a.saida:
        os.makedirs(os.path.dirname(os.path.abspath(a.saida)), exist_ok=True)
        with open(a.saida, 'w', encoding='utf-8') as f:
            f.write('\n'.join(linhas) + '\n')
    sys.exit(2 if inconclusivo else 0)


if __name__ == '__main__':
    main()
