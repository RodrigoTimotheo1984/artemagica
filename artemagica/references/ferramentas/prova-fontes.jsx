#include "<skill>/references/ferramentas/receitas.jsx"
// Prova de fontes: desenha o texto em cada fonte candidata, branco sobre preto, nas caixas medidas no molde
// (medir.ps1 texto), e salva um PNG por candidata. Depois: medir.ps1 fonte ordena pela coincidência com o molde.
// Copie para o job (revisao/prova-fontes.jsx), mude só o CFG e rode pelo COM. Não abre nem altera o PSD do job.
(function () {
    var CFG = {
        saida: '<pasta do job>/revisao/fontes/',
        regiao: { x: 780, y: 580, w: 690, h: 170 },     // a mesma -Regiao do medir.ps1 (px do molde)
        linhas: [{ texto: 'Linha 1 exata', x: 0, y: 0, w: 100, h: 20 }],   // caixas do medir.ps1 texto (px do molde)
        // nome PostScript; negrito = negrito falso; altura = escala vertical em % (máx. 105) quando a fonte for baixa
        candidatas: [
            { fonte: 'Aileron-Black' }, { fonte: 'Aileron-Heavy', negrito: true }, { fonte: 'ArialRoundedMTBold' },
            { fonte: 'FranklinGothic-Heavy' }, { fonte: 'FRITZrounded700' }, { fonte: 'Octopus_Rounded_700' }
        ],
        tracking: 0,
        ajuste: 'altura'   // todas as fontes com a mesma altura do molde; a largura fecha pelo espaçamento (justo para comparar)
    };
    var pasta = new Folder(CFG.saida); if (!pasta.exists) pasta.create();
    var old = app.displayDialogs; app.displayDialogs = DialogModes.NO;
    var Rg = CFG.regiao, rel = [];
    try {
        for (var c = 0; c < CFG.candidatas.length; c++) {
            var K = CFG.candidatas[c], ok = false;
            for (var f = 0; f < app.fonts.length; f++) if (app.fonts[f].postScriptName === K.fonte) { ok = true; break; }
            if (!ok) { rel.push(K.fonte + ': não instalada'); continue; }
            var doc = app.documents.add(UnitValue(Rg.w, 'px'), UnitValue(Rg.h, 'px'), 72, 'prova-fonte', NewDocumentMode.RGB, DocumentFill.TRANSPARENT);
            var preto = new SolidColor(); preto.rgb.hexValue = '000000';
            doc.selection.selectAll(); doc.selection.fill(preto); doc.selection.deselect();
            var g = doc.layerSets.add(), difs = []; g.name = 'linhas';
            for (var i = 0; i < CFG.linhas.length; i++) {
                var L = CFG.linhas[i];
                var r = R.textoMolde(doc, g, 'L' + i, L.texto, { x: L.x - Rg.x, y: L.y - Rg.y, w: L.w, h: L.h },
                    { fonte: K.fonte, negrito: K.negrito, tracking: K.tracking === undefined ? CFG.tracking : K.tracking, cor: '#FFFFFF', entre: K.altura, ajuste: CFG.ajuste });
                difs.push('corpo ' + r.corpo + ' pt, espaçamento ' + r.tracking + ', largura ' + r.difLargura + '%, altura ' + r.difAltura + '%');
            }
            var nome = K.fonte + (K.negrito ? '+negrito' : '') + (K.altura ? '+alt' + K.altura : '') + (K.tracking ? '+trk' + K.tracking : '');
            R.exportarProva(doc, CFG.saida + nome + '.png');
            doc.close(SaveOptions.DONOTSAVECHANGES);
            rel.push(nome + ': ' + difs.join(', '));
        }
    } finally { app.displayDialogs = old; }
    return 'PROVA_FONTES_OK\n' + rel.join('\n');
})();
