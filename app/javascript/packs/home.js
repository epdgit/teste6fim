
var quantidadeJogos = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
var mega = {
  numeros: [6,7,8,9,10,11,12,13,14,15],
  valor: [4.50, 31.50, 126.00, 378.00, 945.00, 2079.00, 4158.00,7722.00, 13513.50, 22522.50],
  probabilidade: ["50.063.860", "7.151.980", "1.787.995", "595.998", "238.399", "108.363", "54.182", "29.175", "16.671", "10.003"]
};

var dupla = {
  numeros: [6,7,8,9,10,11,12,13,14,15],
  valor: [2.50, 17.50, 70.00, 210.00, 525.00, 1155.00, 2310.00, 4290.00, 7507.50, 12512.50],
  probabilidade: ["15.890.700", "2.270.100", "567.525", "189.175", "75.670", "34.395", "17.197", "9.260", "5.291", "3.174"]
};

var quina = {
  numeros: [5,6,7,8,9,10,11,12,13,14,15],
  valor: [2.00, 12.00, 42.00, 112.00, 252.00, 504.00, 924.00, 1584.00, 2574.00, 4004.00, 6006.00],
  probabilidade: ["24.040.016", "4.006.669", "1.144.763", "429.286", "190.794", "95.396", "52.035", "30.354", "18.679", "12.008", "8.005"]
};

var lotof = {
  numeros: [15, 16, 17, 18, 19, 20],
  valor: [2.50, 40.00, 340.00, 2040.00, 9690.00, 38760.00],
  probabilidade: ["3.268.760", "204.298", "24.035", "4.006", "843", "211"]
};

// console.log(quina.numeros[1])

function trocarSeletorNumeros() {
  var sorteioEscolhido = document.getElementById("sorteio");
  var sorteio ;
  if (sorteioEscolhido.value == "mega") {
    sorteio = mega
  } else if (sorteioEscolhido.value == "quina") {
    sorteio = quina
  } else if (sorteioEscolhido.value == "dupla") {
    sorteio = dupla
  } else if (sorteioEscolhido.value == "lotof") {
    sorteio = lotof
  };
  //criando seletores para números a apostar
  var seletorNumeros = document.getElementById("opcoesDaAposta");
  var length = sorteio.numeros.length;
  var opcoesDeNumeros = ""; 
  for (var i = 0; i < length; i++) { //aqui, i é o elemento do array
    opcoesDeNumeros += "<option value='" + sorteio.numeros[i] + "'"+ " >" + sorteio.numeros[i] + "</option>"; 
  };
  
  //criando seletores para quantidade de apostas
  var seletorQuantidade = document.getElementById("quantidade");
  // var opcoesQuantidadeJogos = '<option value="">Selecione</option>';
  var opcoesQuantidadeJogos = '';
  var lengthQuantidade = quantidadeJogos.length;
  for (var i = 0; i < lengthQuantidade; i++) { //aqui, i é o elemento do array
    opcoesQuantidadeJogos += "<option value='" + quantidadeJogos[i] + "'"+ " >" + quantidadeJogos[i] + "</option>"; 
  };
  seletorNumeros.innerHTML = opcoesDeNumeros; //seletor de números a apostas
  seletorQuantidade.innerHTML = opcoesQuantidadeJogos; //quantidade de apostas
}


  // FUNÇÃO PARA SELECIONAR TODAS AS QUOTAS COMO PAGAS
  function selectAll() {
      var blnChecked = document.getElementById("todos_pagos").checked;
      var check_pagamentoS = document.getElementsByClassName("pagamento");
      var intLength = check_pagamentoS.length;
      for(var i = 0; i < intLength; i++) {
          var check_pagamento = check_pagamentoS[i];
          check_pagamento.checked = blnChecked;
      }
  }


function checaPagamentos() {
  var blnChecked = document.getElementById("todos_pagos")
  var check_pagamentoS = document.getElementsByClassName("pagamento");
  var intLength = check_pagamentoS.length;
  var total = 0;
  for(var i = 0; i < intLength; i++) {
      var check_pagamento = check_pagamentoS[i];
      if (check_pagamento.checked == false) {
        total += 1
      };
  if ( total > 0 ) {
    blnChecked.checked = false;
  } else if (total == 0) {
    blnChecked.checked = true;
  }
  }
}


function opcoesBolao() {
  var fazerBolaoSim = document.getElementById("bolaoSim");
  var fazerBolaoNao = document.getElementById("bolaoNao");

  if (fazerBolaoSim.checked) {
    document.getElementById("totalizador_de_apostas_sem_bolao").setAttribute("style", "display: none")
    document.getElementById("divDoBolao").setAttribute("style", "")
    document.getElementById("quantidadeApostadores2").required = true
    // document.getElementById("bolaoSim").setAttribute("checked", "checked")
    // document.getElementById("bolaoNao").checked = false;
    // fazerBolaoNao.removeAttribute("checked")


    //criando seletores para o número de apostadores do bolão:
    var arrayDeCem = Array.from(Array(100).keys()); // cria array de 0 a 99
    var arrayDeCemNovo = arrayDeCem.map(num => num + 1); // soma 1 a cada elemento do array anterior, ou seja, cria array de 1 a 100
    arrayDeCemNovo.splice(0, 1); // isso retira 1 item do array, começando pelo índice 0, fazendo ele começar pelo número 2
    var seletorApostadores = document.getElementById("quantidadeApostadores2");
    // seletorApostadores.required = true
    var length = arrayDeCemNovo.length;
    var opcoesDeApostadores = '<option value="">Selecione</option>'; 
    for (var i = 0; i < length; i++) { //aqui, i é o elemento do array
      opcoesDeApostadores += "<option value='" + arrayDeCemNovo[i] + "'"+ " >" + arrayDeCemNovo[i] + "</option>"; 
    };
    seletorApostadores.innerHTML = opcoesDeApostadores; //seletor de apostadores criado

    // ALTERANDO O FORM PARA CRIAR BOLÃO NO MÉTODO POST
    document.getElementById("teste").setAttribute("method", "POST");
    document.getElementById("teste").setAttribute("action", "/apostas");
    
    // RETIRANDO DADOS CRIADOS DAS APOSTAS GERADAS NA PRÓPRIA HOME
    var retirar = document.getElementById("apostas-geradas")
    if (retirar) {
      retirar.remove()
    };
    
  } else if (fazerBolaoNao.checked) {
    document.getElementById("totalizador_de_apostas_sem_bolao").setAttribute("style", "")
    document.getElementById("divDoBolao").setAttribute("style", "display: none")
    document.getElementById("quantidadeApostadores2").required = false

    //FAZENDO TODOS OS CAMPOS DE APOSTADORES DESAPARECEREM EM CASO DE OPÇÃO NÃO FAZER BOLÃO
    var campos_bolao = document.getElementById("campos_bolao")
    while (campos_bolao.hasChildNodes()) {
      campos_bolao.removeChild(campos_bolao.firstChild)
    };

    //FAZENDO O CHECK DE TODOS PAGOS DESAPARECER SE FOR ESCOLHIDO NÃO FAZER O BOLÃO
    document.getElementById("todos_pagos").checked = false

    // ALTERANDO O FORM PARA TIRAR MÉTODO POST (CRIADO QUANDO DO BOLÃO)
    document.getElementById("teste").removeAttribute("method");
    document.getElementById("teste").setAttribute("action", "/");
    
  };
};

//DEIXANDO HABILITADO OU DESABILITADO A OPÇÃO DE QUOTAS
function opcoesQuotas() {
  var bolaoQuotasSim = document.getElementById("bolaoQuotasSim");
  var bolaoQuotasNao = document.getElementById("bolaoQuotasNao");
  if (bolaoQuotasSim.checked) {
    // fazerBolaoNao.checked == false
    // document.getElementsByClassName("quantidadeQuotas").removeAttribute("disabled")
    var quotaS = document.getElementsByClassName("quantidadeQuotas");
    var intLength = quotaS.length;
    var total = 0;
    for(var i = 0; i < intLength; i++) {
        var quota = quotaS[i];
        quota.removeAttribute("disabled")
    }

  } else if (bolaoQuotasNao.checked) {

    var quotaS = document.getElementsByClassName("quantidadeQuotas");
    var intLength = quotaS.length;
    var total = 0;
    for(var i = 0; i < intLength; i++) {
        var quota = quotaS[i];
        quota.setAttribute("disabled", "disabled");
        quota.value = 1; 
    }
  };
};  



// TOTALIZANDO AS QUOTAS
function quotasTotais() {
  var inputTodos = document.getElementsByClassName("quantidadeQuotas");
  var totalFim = 0;
  for (var i = 0; i < inputTodos.length; i++) { //aqui, i é o elemento do array
    var valor = parseFloat(inputTodos[i].value);
    totalFim += valor; 
  };
  var inputTotalFim = document.getElementById("total_quotas")
  inputTotalFim.innerHTML = totalFim  
};



// TOTALIZANDO APOSTAS
function totalApostas() {
  var modalidade = document.getElementById("sorteio");
  var numerosAposta = document.getElementById("opcoesDaAposta");
  var quantidadeApostas = document.getElementById("quantidade");
  var valorFinalApostas = 0;
  var sorteio ;
  var corretorDeIndice ;
  if (modalidade.value == "mega") {
    sorteio = mega
    corretorDeIndice = 6

  } else if (modalidade.value == "quina") {
    sorteio = quina
    corretorDeIndice = 5

  } else if (modalidade.value == "dupla") {
    sorteio = dupla
    corretorDeIndice = 6

  } else if (modalidade.value == "lotof") {
    sorteio = lotof
    corretorDeIndice = 15

  };

  var valorApostas = sorteio.valor[parseInt(numerosAposta.value) - corretorDeIndice]
  valorFinalApostas += parseFloat(valorApostas)*parseInt(quantidadeApostas.value)

  // INSERINDO NO TOTALIZADOR BOLÃO
  var inputTotalApostasFim = document.getElementById("total_apostas")
  var valorFinalComVirgula = valorFinalApostas.toFixed(2).toString().replace(".", ',') // esse fixa o decimal com vírgula
  var valorFinal = valorFinalComVirgula.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ".") // esse separa milhar com "."
  inputTotalApostasFim.innerHTML = ("R$ " + valorFinal) 

  // INSERINDO NO TOTALIZADOR SEM BOLÃO
  var inputTotalApostasFim = document.getElementById("teste_total_apostas")
  var valorFinalComVirgula = valorFinalApostas.toFixed(2).toString().replace(".", ',') // esse fixa o decimal com vírgula
  var valorFinal = valorFinalComVirgula.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ".") // esse separa milhar com "."
  inputTotalApostasFim.innerHTML = ("R$ " + valorFinal) 


}








// CRIANDO CAMPOS DE APOSTADORES NO BOLÃO
function trocarQuantidadeCampos() {
  var quantidadeApostadoresBolao = document.getElementById("quantidadeApostadores2");

  //criando campos de apostadores no bolão
  var divCamposBolao = document.getElementById("campos_bolao");
  var campos = ""; 
  for (var i = 1; i <= quantidadeApostadoresBolao.value; i++) { //quantidadeApostadoresBolao.value, é a quantidade de apostadores;  i é o elemento do array
    campos += "<div class='cada_cota'><div class='form-group nome-apostador'><label for='apostador'>" + i + "." + "</label><input type='text' id='apostador' name='apostador" + i + "' maxlength='19' placeholder='Nome (opcional)'></div><div class='form-group pago_e_quota'><label for='pagamento' style='font-size: 17px;'><input type='checkbox' class='pagamento' name='pagamento" + i + "'>pago</label><div id='valor_quota'><input class='quantidadeQuotas' name='Quotas" + i + "' type='number'  value='1' min='0.5' max='20' step='0.5' disabled><label for='quantidadeQuotas' style='margin-bottom: 9px;font-size: 17px;margin-left: 2px;'>quota(s)</label></div></div></div>"; 
  };

  divCamposBolao.innerHTML = campos; //novos campos criados sendo inseridos na div

  var quotasNao = document.getElementById("bolaoQuotasNao");
  quotasNao.checked = true; // PASSA PARA MARCADOR "QUOTAS POR APOSTADOR" PARA NÃO QUANDO TROCA A QUANTIDADE DE APOSTADORES

  var blnChecked = document.getElementById("todos_pagos");
  blnChecked.checked = false; // PASSA PARA MARCADOR TODOS PAGOS PARA FALSO QUANDO TROCA A QUANTIDADE DE APOSTADORES
}


export { trocarSeletorNumeros };
export { selectAll };
export { opcoesBolao };
export { opcoesQuotas };
export { checaPagamentos };
export { trocarQuantidadeCampos };
export { quotasTotais };
export { totalApostas };



