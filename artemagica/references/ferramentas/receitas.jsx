// Biblioteca de receitas da artemagica (ExtendScript). Inclua no montar.jsx do job:
//   #include "<skill>/references/ferramentas/receitas.jsx"
// e chame R.<receita>(doc, ...). Tudo fica editável: camadas de preenchimento com máscara, estilos de camada,
// filtros inteligentes. Nada é pintado direto nos pixels. Cardápio (o que cada uma faz e quando usar): cardapio.md.
// Medidas em px do documento final. Do molde para o final: valor_molde * (largura_final / largura_molde).
// Posição na pilha: a camada nova nasce LOGO ACIMA da camada ativa (e dentro do grupo dela, se ela estiver num grupo).
// Antes de chamar, deixe ativa a camada que deve ficar embaixo: doc.activeLayer = <camada>.
var R = (function () {
    function cT(s) { return charIDToTypeID(s); }
    function sT(s) { return stringIDToTypeID(s); }
    function rgb(hex) {
        var c = new SolidColor(); c.rgb.hexValue = hex.replace('#', '');
        var d = new ActionDescriptor();
        d.putDouble(cT('Rd  '), c.rgb.red); d.putDouble(cT('Grn '), c.rgb.green); d.putDouble(cT('Bl  '), c.rgb.blue); return d;
    }
    function bounds(l) { var b; try { b = l.boundsNoEffects; } catch (e) { b = l.bounds; } return [b[0].as('px'), b[1].as('px'), b[2].as('px'), b[3].as('px')]; }
    function mover(l, x, y) { var b = bounds(l); l.translate(UnitValue(x - b[0], 'px'), UnitValue(y - b[1], 'px')); }
    var MODOS = { normal: 'Nrml', multiplicar: 'Mltp', tela: 'Scrn', sobrepor: 'Ovrl', luzSuave: 'SftL', cor: 'Clr ', escurecer: 'Drkn', clarear: 'Lghn' };

    // Seleção elíptica com borda suave (px). cx, cy = centro; rx, ry = raios.
    function elipse(doc, cx, cy, rx, ry, suave) {
        var d = new ActionDescriptor(), r = new ActionReference(); r.putProperty(cT('Chnl'), cT('fsel')); d.putReference(cT('null'), r);
        var e = new ActionDescriptor();
        e.putUnitDouble(cT('Top '), cT('#Pxl'), cy - ry); e.putUnitDouble(cT('Left'), cT('#Pxl'), cx - rx);
        e.putUnitDouble(cT('Btom'), cT('#Pxl'), cy + ry); e.putUnitDouble(cT('Rght'), cT('#Pxl'), cx + rx);
        d.putObject(cT('T   '), cT('Elps'), e); d.putBoolean(cT('AntA'), true);
        executeAction(cT('setd'), d, DialogModes.NO);
        if (suave > 0) doc.selection.feather(UnitValue(suave, 'px'));
    }

    // Camada de cor chapada (editável: duplo clique muda a cor). Com seleção ativa, a máscara nasce dela.
    function corChapada(doc, nome, hex, opac, modo) {
        var d = new ActionDescriptor(), r = new ActionReference(); r.putClass(sT('contentLayer')); d.putReference(cT('null'), r);
        var u = new ActionDescriptor(), s = new ActionDescriptor(); s.putObject(cT('Clr '), cT('RGBC'), rgb(hex));
        u.putObject(cT('Type'), sT('solidColorLayer'), s); d.putObject(cT('Usng'), sT('contentLayer'), u);
        executeAction(cT('Mk  '), d, DialogModes.NO);
        var l = doc.activeLayer; l.name = nome; l.opacity = opac;
        setModo(l, modo || 'normal');
        return l;
    }
    function setModo(l, modo) {
        var m = { normal: BlendMode.NORMAL, multiplicar: BlendMode.MULTIPLY, tela: BlendMode.SCREEN, sobrepor: BlendMode.OVERLAY,
                  luzSuave: BlendMode.SOFTLIGHT, cor: BlendMode.COLORBLEND, escurecer: BlendMode.DARKEN, clarear: BlendMode.LIGHTEN }[modo];
        if (!m) throw new Error('modo desconhecido: ' + modo); l.blendMode = m;
    }

    // Estilo de camada completo (substitui o anterior). Qualquer item é opcional:
    //   sombra:  { cor, opac, angulo, dist, tam, espalhar }     -> sombra projetada suave
    //   brilho:  { cor, opac, tam, espalhar, modo }              -> brilho externo (halo)
    //   brilhoInterno: { cor, opac, tam, modo }
    //   contorno:{ cor, px, pos: 'fora'|'dentro'|'centro' }     -> SÓ se o molde tiver contorno
    function estilo(doc, l, fx) {
        doc.activeLayer = l;
        var d = new ActionDescriptor(), r = new ActionReference();
        r.putProperty(cT('Prpr'), cT('Lefx')); r.putEnumerated(cT('Lyr '), cT('Ordn'), cT('Trgt')); d.putReference(cT('null'), r);
        var x = new ActionDescriptor(); x.putUnitDouble(cT('Scl '), cT('#Prc'), 100);
        if (fx.sombra) {
            var o = fx.sombra, s = new ActionDescriptor();
            s.putBoolean(cT('enab'), true); s.putEnumerated(cT('Md  '), cT('BlnM'), cT('Mltp'));
            s.putObject(cT('Clr '), cT('RGBC'), rgb(o.cor)); s.putUnitDouble(cT('Opct'), cT('#Prc'), o.opac);
            s.putBoolean(cT('uglg'), false); s.putUnitDouble(cT('lagl'), cT('#Ang'), o.angulo === undefined ? 120 : o.angulo);
            s.putUnitDouble(cT('Dstn'), cT('#Pxl'), o.dist); s.putUnitDouble(cT('Ckmt'), cT('#Pxl'), o.espalhar || 0);
            s.putUnitDouble(cT('blur'), cT('#Pxl'), o.tam); x.putObject(cT('DrSh'), cT('DrSh'), s);
        }
        if (fx.brilho) {
            var g = fx.brilho, e = new ActionDescriptor();
            e.putBoolean(cT('enab'), true); e.putEnumerated(cT('Md  '), cT('BlnM'), cT(MODOS[g.modo || 'tela']));
            e.putObject(cT('Clr '), cT('RGBC'), rgb(g.cor)); e.putUnitDouble(cT('Opct'), cT('#Prc'), g.opac);
            e.putEnumerated(cT('GlwT'), cT('BETE'), cT('SfBL')); e.putUnitDouble(cT('Ckmt'), cT('#Pxl'), g.espalhar || 0);
            e.putUnitDouble(cT('blur'), cT('#Pxl'), g.tam); x.putObject(cT('OrGl'), cT('OrGl'), e);
        }
        if (fx.brilhoInterno) {
            var gi = fx.brilhoInterno, ei = new ActionDescriptor();
            ei.putBoolean(cT('enab'), true); ei.putEnumerated(cT('Md  '), cT('BlnM'), cT(MODOS[gi.modo || 'tela']));
            ei.putObject(cT('Clr '), cT('RGBC'), rgb(gi.cor)); ei.putUnitDouble(cT('Opct'), cT('#Prc'), gi.opac);
            ei.putEnumerated(cT('GlwT'), cT('BETE'), cT('SfBL')); ei.putUnitDouble(cT('blur'), cT('#Pxl'), gi.tam);
            ei.putEnumerated(cT('glwS'), cT('IGSr'), cT('SrcE')); x.putObject(cT('IrGl'), cT('IrGl'), ei);
        }
        if (fx.contorno) {
            var c = fx.contorno, k = new ActionDescriptor(), pos = { fora: 'OutF', dentro: 'InsF', centro: 'CtrF' }[c.pos || 'fora'];
            k.putBoolean(cT('enab'), true); k.putEnumerated(cT('Styl'), cT('FStl'), cT(pos));
            k.putEnumerated(cT('PntT'), cT('FrFl'), cT('SClr')); k.putEnumerated(cT('Md  '), cT('BlnM'), cT('Nrml'));
            k.putUnitDouble(cT('Opct'), cT('#Prc'), 100); k.putUnitDouble(cT('Sz  '), cT('#Pxl'), c.px);
            k.putObject(cT('Clr '), cT('RGBC'), rgb(c.cor)); x.putObject(cT('FrFX'), cT('FrFX'), k);
        }
        d.putObject(cT('T   '), cT('Lefx'), x);
        executeAction(cT('setd'), d, DialogModes.NO);
    }

    return {
        bounds: bounds, mover: mover, estilo: estilo, corChapada: corChapada,

        // TEXTO IGUAL AO MOLDE: cria (ou ajusta) uma linha de texto editável e encaixa na caixa medida
        // (medir.ps1 texto, convertida para o final). Ajusta o corpo pela LARGURA e informa a diferença de altura.
        // opc: { fonte, cor, tracking, negrito (fauxBold), entre: escala vertical em % (95-105) se a altura não bater,
        //        ajuste: 'largura' (padrão: corpo pela largura) | 'altura' (corpo pela altura, largura pelo espaçamento) }
        // Devolve { camada, difLargura%, difAltura%, tracking, corpo }. Altura não bate em mais de ~3%? Troque a fonte
        // (prova-fontes) ou use ajuste 'altura' e confira no olho se o espaçamento resultante parece o do molde.
        textoMolde: function (doc, grupo, nome, conteudo, caixa, opc) {
            var l;
            try { l = grupo.artLayers.getByName(nome); } catch (e) { l = grupo.artLayers.add(); l.kind = LayerKind.TEXT; l.name = nome; }
            var t = l.textItem; t.contents = conteudo; t.font = opc.fonte; t.size = UnitValue(100, 'pt');
            if (opc.cor) { var sc = new SolidColor(); sc.rgb.hexValue = opc.cor.replace('#', ''); t.color = sc; }
            t.tracking = opc.tracking || 0; t.fauxBold = !!opc.negrito;
            t.horizontalScale = 100; t.verticalScale = opc.entre || 100;
            var b = bounds(l);
            if (opc.ajuste === 'altura') {
                // corpo pela ALTURA da caixa; a largura fecha mexendo no espaçamento (tracking). Bom para comparar fontes:
                // todas ficam com a mesma altura e o espaçamento que cada uma precisa aparece em número.
                t.size = UnitValue(100 * caixa.h / (b[3] - b[1]), 'pt');
                var tam = t.size.as('pt'), n = Math.max(1, conteudo.length - 1);
                for (var k = 0; k < 3; k++) {
                    b = bounds(l); var falta = caixa.w - (b[2] - b[0]);
                    if (Math.abs(falta) < 1) break;
                    t.tracking = Math.round(t.tracking + falta / n / tam * 1000);
                }
            } else t.size = UnitValue(100 * caixa.w / (b[2] - b[0]), 'pt');
            b = bounds(l); mover(l, caixa.x, caixa.y); b = bounds(l);
            return { camada: l, difLargura: Math.round(((b[2] - b[0]) / caixa.w - 1) * 1000) / 10,
                     difAltura: Math.round(((b[3] - b[1]) / caixa.h - 1) * 1000) / 10, tracking: t.tracking, corpo: Math.round(t.size.as('pt') * 10) / 10 };
        },

        // NUVEM / NÉVOA LOCAL: mancha oval de cor, borda muito suave, atrás do texto ou de um objeto.
        // o: { cx, cy, rx, ry, suave (px de borda), cor (amostrada: medir.ps1 cor -> sombras ou luzes), opac, modo }
        // Escura atrás de texto claro (modo normal/multiplicar); clara e quente para névoa de luz (modo tela).
        nuvem: function (doc, nome, o) {
            elipse(doc, o.cx, o.cy, o.rx, o.ry, o.suave);
            var l = corChapada(doc, nome, o.cor, o.opac, o.modo); doc.selection.deselect(); return l;
        },

        // NÉVOA DE PROFUNDIDADE: degradê de cor de cima (ou do fundo da cena) para transparente.
        // o: { cor, opac, modo ('tela' clareia, 'normal' cobre), y0, y1 (px onde começa forte e onde some), topo: true = forte em cima }
        nevoaProfundidade: function (doc, nome, o) {
            var d = new ActionDescriptor(), r = new ActionReference(); r.putClass(sT('contentLayer')); d.putReference(cT('null'), r);
            var u = new ActionDescriptor(), g = new ActionDescriptor();
            var grad = new ActionDescriptor(); grad.putString(cT('Nm  '), 'nevoa'); grad.putEnumerated(cT('GrdF'), cT('GrdF'), cT('CstS')); grad.putDouble(cT('Intr'), 4096);
            var cores = new ActionList(), tr = new ActionList();
            for (var i = 0; i < 2; i++) {
                var c = new ActionDescriptor(); c.putObject(cT('Clr '), cT('RGBC'), rgb(o.cor)); c.putEnumerated(cT('Type'), cT('Clry'), cT('UsrS'));
                c.putInteger(cT('Lctn'), i * 4096); c.putInteger(cT('Mdpn'), 50); cores.putObject(cT('Clrt'), c);
                var t = new ActionDescriptor(); t.putUnitDouble(cT('Opct'), cT('#Prc'), i === 0 ? 100 : 0);
                t.putInteger(cT('Lctn'), i * 4096); t.putInteger(cT('Mdpn'), 50); tr.putObject(cT('TrnS'), t);
            }
            grad.putList(cT('Clrs'), cores); grad.putList(cT('Trns'), tr);
            g.putObject(cT('Grad'), cT('Grdn'), grad); g.putEnumerated(cT('Type'), cT('GrdT'), cT('Lnr '));
            g.putUnitDouble(cT('Angl'), cT('#Ang'), o.topo === false ? 90 : -90);
            var H = doc.height.as('px'); g.putUnitDouble(cT('Scl '), cT('#Prc'), Math.max(10, Math.min(150, 100 * (o.y1 - o.y0) / H)));
            g.putObject(cT('Ofst'), cT('Pnt '), (function () { var p = new ActionDescriptor(); p.putUnitDouble(cT('Hrzn'), cT('#Prc'), 0);
                p.putUnitDouble(cT('Vrtc'), cT('#Prc'), 100 * ((o.y0 + o.y1) / 2 - H / 2) / H); return p; })());
            u.putObject(cT('Type'), sT('gradientLayer'), g); d.putObject(cT('Usng'), sT('contentLayer'), u);
            executeAction(cT('Mk  '), d, DialogModes.NO);
            var l = doc.activeLayer; l.name = nome; l.opacity = o.opac; setModo(l, o.modo || 'tela'); return l;
        },

        // SOMBRA DE CONTATO: oval escura e achatada embaixo de um objeto apoiado (carrinho, produto, pé).
        // o: { cx, cy (base do objeto), rx (meia largura do apoio), ry (bem menor: 0,1-0,2 de rx), suave, cor (sombras do molde), opac }
        sombraContato: function (doc, nome, o) {
            elipse(doc, o.cx, o.cy, o.rx, o.ry, o.suave);
            var l = corChapada(doc, nome, o.cor || '#000000', o.opac, 'multiplicar'); doc.selection.deselect(); return l;
        },

        // VINHETA: escurece as bordas. o: { forca (opacidade 0-100), cor, margem (0-0,5 do lado menor), suave }
        vinheta: function (doc, nome, o) {
            var W = doc.width.as('px'), H = doc.height.as('px'), m = (o.margem || 0.15) * Math.min(W, H);
            elipse(doc, W / 2, H / 2, W / 2 - m, H / 2 - m, o.suave || Math.min(W, H) * 0.25);
            doc.selection.invert();
            var l = corChapada(doc, nome, o.cor || '#000000', o.forca, 'multiplicar'); doc.selection.deselect();
            l.move(doc, ElementPlacement.PLACEATBEGINNING); return l;   // sempre no topo, fora de grupos
        },

        // CASAR COR: tinge um elemento recortado com a cor da cena (presa só a ele). Use a cor média da área do molde
        // onde o elemento está (medir.ps1 cor). o: { cor, opac (10-35 costuma bastar), modo: 'luzSuave' | 'cor' }
        casarCor: function (doc, alvo, nome, o) {
            doc.activeLayer = alvo;
            var l = corChapada(doc, nome, o.cor, o.opac, o.modo || 'luzSuave');
            l.move(alvo, ElementPlacement.PLACEBEFORE); l.grouped = true; return l;
        },

        // HALO / BRILHO EM VOLTA de um objeto (selo, luz, produto). o: { cor, opac, tam, espalhar }
        halo: function (doc, alvo, o) { estilo(doc, alvo, { brilho: { cor: o.cor, opac: o.opac, tam: o.tam, espalhar: o.espalhar || 0, modo: 'tela' } }); },

        // DESFOQUE DE PROFUNDIDADE: filtro inteligente (editável) num objeto inteligente. raio em px.
        desfocar: function (doc, alvo, raio) {
            doc.activeLayer = alvo;
            var d = new ActionDescriptor(); d.putUnitDouble(cT('Rds '), cT('#Pxl'), raio);
            executeAction(cT('GsnB'), d, DialogModes.NO);
        },

        // PROVA RÁPIDA: exporta o documento inteiro em PNG para o medir.ps1 recorte comparar com o molde.
        exportarProva: function (doc, caminho) {
            var o = new ExportOptionsSaveForWeb(); o.format = SaveDocumentType.PNG; o.PNG8 = false; o.includeProfile = true;
            doc.exportDocument(new File(caminho), ExportType.SAVEFORWEB, o);
        }
    };
})();
