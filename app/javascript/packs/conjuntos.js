//CRIANDO LÓGICA DOS SELETORES QUANTIDADE JOGOS E NÚMEROS POR APOSTA


function trocarSeletorNumerosConjuntos() {

  var conjuntoArraydaSorteDiretoDoForm = document.getElementById("numeros-da-sorte-fim2").value.split(",")
  var conjuntoFim = []
  for(var i = 0; i < conjuntoArraydaSorteDiretoDoForm.length; i++) {
    conjuntoFim.push(parseInt(conjuntoArraydaSorteDiretoDoForm[i])) // convetendo o array de strings para array de integers
  }
 
 
 
 //POSSIBILIDADE DE NÚMEROS POR APOSTA
  var numerosPossiveis =  [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    //criando seletores para números a apostar
  var seletorNumeros = document.getElementById("opcoesDaAposta21");
  var length = numerosPossiveis.length;
  var opcoesDeNumeros = "<option value=''>Selecione</option>";
  var quantidadeMarcada = conjuntoFim.length
  var arrayTemp = []
  for (var i = 0; i < length; i++) { //aqui, i é o elemento do array
    if (quantidadeMarcada >= numerosPossiveis[i]) {
      arrayTemp.push(numerosPossiveis[i])
    }
  };
  var len2 = arrayTemp.length
  for (var i = 0; i < len2; i++) { //aqui, i é o elemento do array
      opcoesDeNumeros += "<option value='" + arrayTemp[i] + "'"+ " >" + arrayTemp[i] + "</option>"; 
  };
  seletorNumeros.innerHTML = opcoesDeNumeros; //seletor de números a apostas
}


function trocarSeletorQuantidadeApostasConjuntos() {

  // RECUPERANDO ARRAY DA SORTE DIRETO DO FORME E CHAMANDO-O DE conjuntoFim
  var conjuntoArraydaSorteDiretoDoForm = document.getElementById("numeros-da-sorte-fim2").value.split(",")
  var conjuntoFim = []
  for(var i = 0; i < conjuntoArraydaSorteDiretoDoForm.length; i++) {
    conjuntoFim.push(parseInt(conjuntoArraydaSorteDiretoDoForm[i])) // convetendo o array de strings para array de integers
  }

  //CALCULANDO FATORIAL
  function calcularFatorial (n) {
    if (n === 1) {
        return 1;
    }
    
    return n * calcularFatorial (n - 1);
  }

  //CALCULANDO COMBINAÇÕES POSSÍVEIS DO CONJUNTO DE N NÚMEROS TOMADO x A x
  function combinacoesPossiveis (nNumeros, tomadosXaX) {
    if (nNumeros == tomadosXaX) {
      return 1
    } else {
      return calcularFatorial(nNumeros)/(calcularFatorial(tomadosXaX)*calcularFatorial(nNumeros-tomadosXaX))
    }
  }
  var numerosPorAposta = document.getElementById("opcoesDaAposta21")
  var maximoDeCombinacoes = combinacoesPossiveis (conjuntoFim.length, parseInt(numerosPorAposta.value))



  // QUANTIDADE DE APOSTAS
  var construtor = []
  var quantidadesPossiveis = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  for (var i = 0; i < quantidadesPossiveis.length; i++) { //aqui, i é o elemento do array
    if (quantidadesPossiveis[i] <= maximoDeCombinacoes) {
      construtor.push(quantidadesPossiveis[i])
    }
  };




  //criando seletores para quantidade de apostas
  var seletorQuantidade = document.getElementById("quantidade2");
  // var opcoes2 = '<option value="">Selecione</option>';
  var opcoes2 = '';
  var lengthQuantidadeConstrutor = construtor.length;
  for (var i = 0; i < lengthQuantidadeConstrutor; i++) { //aqui, i é o elemento do array
    opcoes2 += "<option value='" + construtor[i] + "'"+ " >" + construtor[i] + "</option>"; 
  };
  seletorQuantidade.innerHTML = opcoes2; //quantidade de apostas


}



export { trocarSeletorNumerosConjuntos };
export { trocarSeletorQuantidadeApostasConjuntos };