// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"
import "bootstrap"


import { trocarSeletorNumeros } from './home';
import { selectAll } from './home';
import { opcoesBolao } from './home';
import { opcoesQuotas } from './home';
import { checaPagamentos } from './home';
import { trocarQuantidadeCampos } from './home';
import { quotasTotais } from './home';
import { totalApostas } from './home';
import { salvarPDF } from './apostas';
import { trocarSeletorNumerosConjuntos }  from './conjuntos';
import { trocarSeletorQuantidadeApostasConjuntos } from './conjuntos';
// import { trocarIdDiv } from './home';

// Dando relood na volta à página Home:
var reloadRoot = document.getElementById("botao-root");
if(reloadRoot) {
  reloadRoot.addEventListener("click", () => {
    location.assign('/'); // faz a página para a qual vai dar um relood, tornando possível a execução dos arquivos javascript
  });
}

var reloadConjuntos = document.getElementById("botao-conjuntos");
if(reloadConjuntos) {
  reloadConjuntos.addEventListener("click", () => {
    location.assign('/conjuntos'); // faz a página para a qual vai dar um relood, tornando possível a execução dos arquivos javascript
  });
}

var reloadSorte = document.getElementById("botao-sorte");
if(reloadSorte) {
  reloadSorte.addEventListener("click", () => {
    location.assign('/sorte'); // faz a página para a qual vai dar um relood, tornando possível a execução dos arquivos javascript
  });
}

var reloadSorteios = document.getElementById("botao-sorteios");
if(reloadSorteios) {
  reloadSorteios.addEventListener("click", () => {
    location.assign('/sorteios'); // faz a página para a qual vai dar um relood, tornando possível a execução dos arquivos javascript
  });
}

var reloadEstatistica = document.getElementById("botao-estatistica");
if(reloadEstatistica) {
  reloadEstatistica.addEventListener("click", () => {
    location.assign('/estatistica'); // faz a página para a qual vai dar um relood, tornando possível a execução dos arquivos javascript
  });
}

var salvaPDF = document.getElementById("meu-pdf");
if(salvaPDF) { // SÓ EXECUTA A FUNÇÃO SE ESTIVER NA PÁGINA APOSTAS
  salvaPDF.addEventListener("click", () => {
    salvarPDF()
  });
}


var sorteioEscolhido = document.getElementById("sorteio");
if (sorteioEscolhido) {
  sorteioEscolhido.addEventListener("change", () => {
    trocarSeletorNumeros()
    totalApostas()
  });
}

var numerosAposta = document.getElementById("opcoesDaAposta");
if (numerosAposta) {
  numerosAposta.addEventListener("change", () => {
    totalApostas()
  })
}

var quantidadeCartoes = document.getElementById("quantidade");
if (quantidadeCartoes) {
  quantidadeCartoes.addEventListener("change", () => {
    totalApostas()
  })
}


var fazerBolaoSim = document.getElementById("bolaoSim");
var fazerBolaoNao = document.getElementById("bolaoNao");
if (fazerBolaoSim) {
  fazerBolaoSim.addEventListener("click", () => {
    opcoesBolao()
  });
}
if (fazerBolaoNao) {
  fazerBolaoNao.addEventListener("click", () => {
  //  trocarQuantidadeCampos() // testar se desaparecem os campos
    opcoesBolao()
    quotasTotais() //TESTAR SE FICA ZERADO O CONTADOR DE QUOTAS
  });
}

var camposBolao = document.getElementById("quantidadeApostadores2");
if (camposBolao) {
  camposBolao.addEventListener("change", () => {
    trocarQuantidadeCampos()
    quotasTotais() // faz a soma das quotas quando informado o nº de apostadores
  });
}



var bolaoQuotasSim = document.getElementById("bolaoQuotasSim");
var bolaoQuotasNao = document.getElementById("bolaoQuotasNao");
if (bolaoQuotasSim) {
  bolaoQuotasSim.addEventListener("click", () => {
    opcoesQuotas()
  });
}
if (bolaoQuotasNao) {
  bolaoQuotasNao.addEventListener("click", () => {
    opcoesQuotas()
    quotasTotais() // faz a soma das quotas quando informado que não quer informar quotas
  });
}


var blnChecked = document.getElementById("todos_pagos")
if (blnChecked) {
  blnChecked.addEventListener("click", () => {
    selectAll()
  });
}

var inputBolao = document.getElementById("campos_bolao");
if (inputBolao) {
  inputBolao.addEventListener("click", () => {
    quotasTotais()
  });
}



var todosPagos = document.getElementById("todos_apostadores");
if (todosPagos) {
  todosPagos.addEventListener("click", () => {
    checaPagamentos()
  });
}


var conjuntoArraydaSorteDiretoDoForm = document.getElementById("numeros-da-sorte-fim2")
if (conjuntoArraydaSorteDiretoDoForm) {
  conjuntoArraydaSorteDiretoDoForm.addEventListener("change", () => {
    trocarSeletorNumerosConjuntos()
  });
}

var conjuntosNumerosPorAposta = document.getElementById("opcoesDaAposta21");
if (conjuntosNumerosPorAposta) {
  conjuntosNumerosPorAposta.addEventListener("change", () => {
    trocarSeletorQuantidadeApostasConjuntos()
  });
}

