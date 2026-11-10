// Reabre um PSD salvo da artemagica e confere o que o painel nao mostra. Ajuste PSD antes de rodar.
// NAO TESTADO (v2, 02/11/2026): primeiro teste no Codex.
// - recusa rodar se o PSD ja estiver aberto (feche, ou rode numa copia);
// - conta os itens do primeiro nivel e o total, e aponta sobras ("Camada 1", prova, teste, temporaria...);
// - acha mascara toda preta (esconde a camada inteira) ou toda branca (nao recorta nada);
// - exporta uma prova em sRGB do estado salvo (e de cada composicao, se houver: a skill pede um estado so);
// - grava o relatorio em revisao/verificado-<psd>.txt e fecha sem salvar.
(function () {
    var PSD = '<pasta do job>/editaveis/<slug>-<formato>.psd';
    var file = new File(PSD), mode = app.displayDialogs;
    if (!file.exists) throw new Error('PSD inexistente: ' + PSD);
    for (var i = 0; i < app.documents.length; i++) {
        if (app.documents[i].fullName.fsName === file.fsName) throw new Error('PSD ja esta aberto no Photoshop: feche ou rode numa copia. Nada foi alterado.');
    }
    function c(s) { return charIDToTypeID(s); }
    function s(t) { return stringIDToTypeID(t); }
    var root = file.parent.parent.fsName, provas = new Folder(root + '/revisao/provas');
    if (!provas.exists) provas.create();
    var base = file.name.replace(/\.psd$/i, ''), doc;
    try {
        app.displayDialogs = DialogModes.NO;
        doc = app.open(file);
        var W = doc.width.as('px'), H = doc.height.as('px');
        var topo = [], todos = [], sobras = [], textos = [], mascaras = [], alertas = [];
        var SOBRA = /^(camada|layer) \d+$|prova|teste|tempor|tentativa|copiar|copy|backup/i;

        for (var t = 0; t < doc.layers.length; t++) {
            var l0 = doc.layers[t];
            topo.push((t + 1) + '. ' + l0.name + ' [' + (l0.typename === 'LayerSet' ? 'grupo' : String(l0.kind).replace('LayerKind.', '')) + ']' + (l0.visible ? '' : ' (oculta)'));
        }
        function walk(cont) {
            for (var k = 0; k < cont.layers.length; k++) {
                var l = cont.layers[k];
                todos.push(l);
                if (SOBRA.test(l.name)) sobras.push(l.name);
                if (l.typename === 'LayerSet') walk(l);
                else if (l.kind === LayerKind.TEXT) textos.push(l.name + ': "' + l.textItem.contents + '" (' + l.textItem.font + ')');
            }
        }
        walk(doc);

        // composicoes: aplicar e exportar uma prova de cada (copia achatada, convertida para sRGB)
        var comps = [];
        function exportar(nome) {
            var dup = doc.duplicate('prova', true);
            dup.convertProfile('sRGB IEC61966-2.1', Intent.RELATIVECOLORIMETRIC, true, false);
            var out = new File(provas.fsName + '/verificar-' + base + '-' + nome.replace(/[^\w\-]+/g, '_') + '.png');
            dup.saveAs(out, new PNGSaveOptions(), true, Extension.LOWERCASE);
            dup.close(SaveOptions.DONOTSAVECHANGES);
            app.activeDocument = doc;
            return out.fsName;
        }
        comps.push('(estado salvo) -> ' + exportar('estado-salvo'));
        if (doc.layerComps.length > 0) {
            alertas.push('tem composicoes de camadas: a skill pede um estado so, bonito e editavel; confira se o estado salvo e o entregue');
        }
        for (var p = 0; p < doc.layerComps.length; p++) {
            var comp = doc.layerComps[p];
            comp.apply();
            var ligados = [];
            for (var q = 0; q < doc.layers.length; q++) if (doc.layers[q].visible) ligados.push(doc.layers[q].name);
            comps.push(comp.name + ' -> ' + exportar(comp.name) + '\n   ligados no topo: ' + ligados.join(' | '));
        }

        // mascaras: carregar a mascara como selecao; vazia = toda preta; inverso vazio = toda branca
        function selecionar(id) {
            var d = new ActionDescriptor(), r = new ActionReference();
            r.putIdentifier(c('Lyr '), id); d.putReference(c('null'), r); d.putBoolean(c('MkVs'), false);
            executeAction(c('slct'), d, DialogModes.NO);
        }
        function temMascara(id) {
            var r = new ActionReference(); r.putIdentifier(c('Lyr '), id);
            var d = executeActionGet(r);
            return d.hasKey(s('hasUserMask')) && d.getBoolean(s('hasUserMask'));
        }
        function selecaoVazia() { try { doc.selection.bounds; return false; } catch (e) { return true; } }
        for (var m = 0; m < todos.length; m++) {
            var lm = todos[m];
            if (!temMascara(lm.id)) continue;
            selecionar(lm.id);
            var d2 = new ActionDescriptor(), r1 = new ActionReference(), r2 = new ActionReference();
            r1.putProperty(c('Chnl'), c('fsel')); d2.putReference(c('null'), r1);
            r2.putEnumerated(c('Chnl'), c('Chnl'), c('Msk ')); d2.putReference(c('T   '), r2);
            executeAction(c('setd'), d2, DialogModes.NO);
            var estado = 'ok';
            if (selecaoVazia()) estado = 'TODA PRETA (esconde a camada inteira)';
            else { doc.selection.invert(); if (selecaoVazia()) estado = 'TODA BRANCA (nao recorta nada)'; }
            doc.selection.deselect();
            mascaras.push(lm.name + ': ' + estado);
            if (estado !== 'ok') alertas.push('mascara ' + estado.split(' (')[0].toLowerCase() + ': ' + lm.name);
        }

        if (doc.layers.length > 30) alertas.push(doc.layers.length + ' itens no primeiro nivel (meta: ate ~30)');
        if (sobras.length) alertas.push(sobras.length + ' possiveis sobras: ' + sobras.join(' | '));

        var rel = 'PSD reaberto: ' + doc.name + '\n' + W + 'x' + H + ' px | perfil: ' + doc.colorProfileName +
            '\n\nATENCAO (' + alertas.length + '):\n' + (alertas.length ? alertas.join('\n') : 'nada') +
            '\n\nPrimeiro nivel (' + doc.layers.length + ' itens):\n' + topo.join('\n') +
            '\n\nTotal de itens: ' + todos.length +
            '\n\nComposicoes e provas (abrir e olhar cada uma):\n' + comps.join('\n') +
            '\n\nMascaras (' + mascaras.length + '):\n' + mascaras.join('\n') +
            '\n\nTextos editaveis (' + textos.length + '):\n' + textos.join('\n');
        var out = new File(root + '/revisao/verificado-' + base + '.txt');
        out.encoding = 'UTF8'; out.open('w'); out.write(rel); out.close();
        return rel;
    } finally {
        if (doc) doc.close(SaveOptions.DONOTSAVECHANGES);
        app.displayDialogs = mode;
    }
}());
