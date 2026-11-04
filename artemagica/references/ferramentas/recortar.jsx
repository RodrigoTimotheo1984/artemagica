#target photoshop
// Recorta o fundo liso com o Selecionar assunto do Photoshop e salva <nome>-recorte.png (transparente) ao lado do original.
// Copie para a pasta do job e mude so o CFG. Caminhos relativos a pasta deste script. O original nao e alterado.
var CFG = {
  arquivos: [
    'kv-a/assets/gerados/originais/kv-a-personagem-tentativa1.png'
  ]
};

var raiz = File($.fileName).parent;
var dialogos = app.displayDialogs;
var feitos = [];
try {
  app.displayDialogs = DialogModes.NO;
  for (var i = 0; i < CFG.arquivos.length; i++) {
    var f = File(raiz + '/' + CFG.arquivos[i]);
    if (!f.exists) { feitos.push('FALTA: ' + CFG.arquivos[i]); continue; }
    var saida = File(f.fullName.replace(/\.[^.\/]+$/, '') + '-recorte.png');
    if (saida.exists) { feitos.push('JA EXISTE: ' + saida.name); continue; }
    var doc = app.open(f);
    try {
      doc.activeLayer.isBackgroundLayer = false;
      // Selecionar assunto
      var a = new ActionDescriptor();
      a.putBoolean(stringIDToTypeID('sampleAllLayers'), false);
      executeAction(stringIDToTypeID('autoCutout'), a, DialogModes.NO);
      // Mascara a partir da selecao
      var mk = new ActionDescriptor();
      mk.putClass(charIDToTypeID('Nw  '), charIDToTypeID('Chnl'));
      var ref = new ActionReference();
      ref.putEnumerated(charIDToTypeID('Chnl'), charIDToTypeID('Chnl'), charIDToTypeID('Msk '));
      mk.putReference(charIDToTypeID('At  '), ref);
      mk.putEnumerated(charIDToTypeID('Usng'), charIDToTypeID('UsrM'), charIDToTypeID('RvlS'));
      executeAction(charIDToTypeID('Mk  '), mk, DialogModes.NO);
      doc.saveAs(saida, new PNGSaveOptions(), true, Extension.LOWERCASE);
      feitos.push('OK: ' + saida.name);
    } finally {
      doc.close(SaveOptions.DONOTSAVECHANGES);
    }
  }
} finally {
  app.displayDialogs = dialogos;
}
feitos.join('\n');
