import html2canvas from 'html2canvas';
window.jsPDF = window.jspdf.jsPDF;




function salvarPDF() {

  // FORMATANDO DATA E HORA
  var dataHoje = new Date().toLocaleDateString('en-GB');
  var dataHoje2 = new Date()
  var hora = dataHoje2.getHours().toString().padStart(2, '0') + ':' + dataHoje2.getMinutes().toString().padStart(2, '0') + ':' + dataHoje2.getSeconds().toString().padStart(2, '0');
  var dataHora = dataHoje + " às " + hora;
  var horaNominarArquivo = dataHoje2.getHours().toString().padStart(2, '0') + dataHoje2.getMinutes().toString().padStart(2, '0') + dataHoje2.getSeconds().toString().padStart(2, '0');  
  //obs.: .padStart(2, '0'); checa se a string tem 2 caracteres, se não tiver, preenche o primeiro com zero!!!


  var doc = new jsPDF({unit: 'pt', format: [1400, 2000], orientation: 'portrait' });
  var printar = document.getElementById("printar_pdf")
  var printarClonado = printar.cloneNode(true) // clonando o elemento acima para alterar suas confirgurações de largura
  // var widthPDF = doc.internal.pageSize.getWidth();
  printarClonado.style.width = "1400px";
  // printarClonado.setAttribute("style", `width: ${1200}`)
  // const html2canvas = require('html2canvas');
  // window.html2canvas = html2canvas;
  window["html2canvas"] = html2canvas;
  doc.html(printarClonado, {
    autoPaging: 'text',
    margin: [120, 0, 120, 0],
    html2canvas: { scale: 1.0}, //  html2canvas: { scale: 1.0, ignoreElements: element => element.id === autoTableConfig?.elementId },
    callback: function (doc) {

      //criando um texto eTarta.com.br e centralizando o conteúdo
      var width = doc.internal.pageSize.getWidth()
      doc.setFontSize(15);
      doc.setTextColor("#204A65");


      let pageInfo = doc.setPage(1); // pegando a primeira página para só nela lançar dados
      console.log(pageInfo.pageNumber)
      pageInfo.text(width/2, 163, "eTARTA.com.br", {align:  'center'});
      pageInfo.text(1100, 40, dataHora);
      
      //PAGINANDO O DOCUMENTO
      const pageCount = doc.internal.getNumberOfPages();
      // console.log(pageCount);
      for (var i = 1; i <= pageCount; i++) {
        doc.setPage(i)
        doc.text('Página ' + String(i) + ' de ' + String(pageCount), 1100, 1960)
       }
      // let pageInfo = doc.internal.getCurrentPageInfo();
      // console.log(pageInfo.pageNumber)
      // if(pageInfo.pageNumber == 1) {
      //   doc.text(width/2, 202, "eTARTA.com.br", {align:  'center'});
      //   doc.text(1100, 40, dataHora);
      // }

      // doc.addImage("")
      // doc.internal.scaleFactor;

      // var pageCount = doc.internal.getNumberOfPages(); //Total Page Number
      // for(i = 0; i < pageCount; i++) { 
      //   doc.setPage(i); 
      //   let pageCurrent = doc.internal.getCurrentPageInfo().pageNumber; //Current Page
      //   doc.setFontSize(12);
      //   doc.text('page: ' + pageCurrent + '/' + pageCount, 10, doc.internal.pageSize.height - 10);
      // }




      //salvando o pdf
      doc.save(`eTarta_${horaNominarArquivo}.pdf`);
    },
    // filename: ,
    // orientation: 'portrait',
    // format: 'a4',
    // unit: 'mm',
    // scale: 1,
    // width: 50,
    // autoPaging: 'text',
    x: 10,
    y: 10
});

}

export { salvarPDF };