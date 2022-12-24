class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :apostas, :sorte, :conjuntos, :estatistica ]

  MEGA = {
    numeros: [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
    valor: [4.50, 31.50, 126.00, 378.00, 945.00, 2079.00, 4158.00,7722.00, 13513.50, 22522.50, 36036.00, 55692.00, 83538.00, 122094.00, 174420.00],
    probabilidade: [50063860, 7151980, 1787995, 595998, 238399, 108363, 54182, 29175, 16671, 10003, 6252, 4045, 2697, 1845, 1292]
  };
  
  DUPLA = {
    numeros: [6,7,8,9,10,11,12,13,14,15],
    valor: [2.50, 17.50, 70.00, 210.00, 525.00, 1155.00, 2310.00, 4290.00, 7507.50, 12512.50],
    probabilidade: [15890700, 2270100, 567525, 189175, 75670, 34395, 17197, 9260, 5291, 3174]
  };

  QUINA = {
    numeros: [5,6,7,8,9,10,11,12,13,14,15],
    valor: [2.00, 12.00, 42.00, 112.00, 252.00, 504.00, 924.00, 1584.00, 2574.00, 4004.00, 6006.00],
    probabilidade: [24040016, 4006669, 1144763, 429286, 190794, 95396, 52035, 30354, 18679, 12008, 8005]
  };

  LOTOF = {
    numeros: [15, 16, 17, 18, 19, 20],
    valor: [2.50, 40.00, 340.00, 2040.00, 9690.00, 38760.00],
    probabilidade: [3268760, 204298, 24035, 4006, 843, 211]
  };

  def home
    Money.locale_backend = nil # Estava dando informação de deprecado o fato de não haver apontamento da localização, mas, se isso não fosse importante, poderia ser usada essa linha de código

    #DIVULGAÇÃO 1
    todos_sorteios = Sorteio.all
    ultimo_sorteio = todos_sorteios.last
    @ultimo_sorteio_numeracao = ultimo_sorteio[:concurso]
    @ultimo_sorteio_data = ultimo_sorteio[:data]
    @ultimo_sorteio_numeros = todos_sorteios.last[:numeros].split(/,/).map {|x| x.to_i}



    @mega = MEGA
    
    @dupla = DUPLA
    
    @quina = QUINA

    @lotof = LOTOF
    
    @array = []
    @conferir = []   # guardará os jogos que serão feitos, mas em um array
    sorteio = params[:sorteio]
    apostas_desejadas = params[:quantidadeJogos].to_i # LANÇAR AQUI QUANTAS APOSTAS VOCÊ DESEJA
    numeros_cada_aposta = params[:quantidadeNumeros].to_i


    if sorteio == "mega"
      (1...61).each { |n| @array << n}
      indice_corretor = 6
      modalidade = @mega
      @nome = 'Mega-sena'
    elsif sorteio == "dupla"
      (1...51).each { |n| @array << n}
      indice_corretor = 6
      modalidade = @dupla
      @nome = 'Dupla sena'
    elsif sorteio == "quina"
      (1...81).each { |n| @array << n}
      indice_corretor = 5
      modalidade = @quina
      @nome = 'Quina'
    elsif sorteio == "lotof"
      (1...26).each { |n| @array << n}
      indice_corretor = 15
      modalidade = @lotof
      @nome = 'Lotofácil'
    end



    while @conferir.count < apostas_desejadas
      if @array.count < numeros_cada_aposta
        @array = []
        if sorteio == "mega"
          (1...61).each { |n| @array << n}
        elsif sorteio == "dupla"
          (1...51).each { |n| @array << n}
        elsif sorteio == "quina"
          (1...81).each { |n| @array << n}
        elsif sorteio == "lotof"
          (1...26).each { |n| @array << n}
        end
      end

      aposta = @array.sample(numeros_cada_aposta).sort
      @conferir << aposta
      @conferir.uniq!
      for x in aposta
        @array.delete(x)
      end

    end

    if numeros_cada_aposta > 0
      valor_total = modalidade[:valor][numeros_cada_aposta - indice_corretor]*apostas_desejadas*100
      formato_money = Money.from_cents(valor_total, "BRL").format
      formato_brasil = formato_money.gsub!(".","*")
      if formato_brasil.include? ","
        formato_brasil.gsub!(",",".")
      end
      formato_brasil.gsub!("*",",")
      @valor = "Valor: #{formato_brasil}."

      @id_div_apostas = "apostas-geradas"

      # condition ? if_true : if_false
      chance = modalidade[:probabilidade][numeros_cada_aposta - indice_corretor]/apostas_desejadas
      @chance_printada = "Sua chance será de 1 em #{chance.to_s.reverse.scan(/.{1,3}/).join('.').reverse}."
    end

    # VALORES APOSTAS SIMPLES E MAIOR APOSTA MEGA
    @valor_aposta_simples_mega = ("%.2f" % @mega[:valor][0]).to_s.gsub!(".",",")
    valor_maior_aposta_mega_temp = ("%.2f" % @mega[:valor].last()).to_s.gsub!(".",",")
    indice_da_virgula_maior_aposta_mega = valor_maior_aposta_mega_temp.to_s.index(",")
    substring_virgula_mais_dois_espacos_mega = valor_maior_aposta_mega_temp.slice(indice_da_virgula_maior_aposta_mega, (indice_da_virgula_maior_aposta_mega + 2))
    @valor_maior_aposta_mega = valor_maior_aposta_mega_temp.split(substring_virgula_mais_dois_espacos_mega)[0].reverse.scan(/.{1,3}/).join('.').reverse + substring_virgula_mais_dois_espacos_mega

    # VALORES APOSTAS SIMPLES E MAIOR APOSTA DUPLA
    @valor_aposta_simples_dupla = ("%.2f" % @dupla[:valor][0]).to_s.gsub!(".",",")
    valor_maior_aposta_dupla_temp = ("%.2f" % @dupla[:valor].last()).to_s.gsub!(".",",")
    indice_da_virgula_maior_aposta_dupla = valor_maior_aposta_dupla_temp.to_s.index(",")
    substring_virgula_mais_dois_espacos_dupla = valor_maior_aposta_dupla_temp.slice(indice_da_virgula_maior_aposta_dupla, (indice_da_virgula_maior_aposta_dupla + 2))
    @valor_maior_aposta_dupla = valor_maior_aposta_dupla_temp.split(substring_virgula_mais_dois_espacos_dupla)[0].reverse.scan(/.{1,3}/).join('.').reverse + substring_virgula_mais_dois_espacos_dupla

    # VALORES APOSTAS SIMPLES E MAIOR APOSTA QUINA
    @valor_aposta_simples_quina = ("%.2f" % @quina[:valor][0]).to_s.gsub!(".",",")
    valor_maior_aposta_quina_temp = ("%.2f" % @quina[:valor].last()).to_s.gsub!(".",",")
    indice_da_virgula_maior_aposta_quina = valor_maior_aposta_quina_temp.to_s.index(",")
    substring_virgula_mais_dois_espacos_quina = valor_maior_aposta_quina_temp.slice(indice_da_virgula_maior_aposta_quina, (indice_da_virgula_maior_aposta_quina + 2))
    @valor_maior_aposta_quina = valor_maior_aposta_quina_temp.split(substring_virgula_mais_dois_espacos_quina)[0].reverse.scan(/.{1,3}/).join('.').reverse + substring_virgula_mais_dois_espacos_quina

    # VALORES APOSTAS SIMPLES E MAIOR APOSTA MEGA
    @valor_aposta_simples_lotof = ("%.2f" % @lotof[:valor][0]).to_s.gsub!(".",",")
    valor_maior_aposta_lotof_temp = ("%.2f" % @lotof[:valor].last()).to_s.gsub!(".",",")
    indice_da_virgula_maior_aposta_lotof = valor_maior_aposta_lotof_temp.to_s.index(",")
    substring_virgula_mais_dois_espacos_lotof = valor_maior_aposta_lotof_temp.slice(indice_da_virgula_maior_aposta_lotof, (indice_da_virgula_maior_aposta_lotof + 2))
    @valor_maior_aposta_lotof = valor_maior_aposta_lotof_temp.split(substring_virgula_mais_dois_espacos_lotof)[0].reverse.scan(/.{1,3}/).join('.').reverse + substring_virgula_mais_dois_espacos_lotof




  end

  def apostas
    Money.locale_backend = nil # Estava dando informação de deprecado o fato de não haver apontamento da localização, mas, se isso não fosse importante, poderia ser usada essa linha de código

    @aposta = params

    @mega = MEGA
    
    @dupla = DUPLA
    
    @quina = QUINA

    @lotof = LOTOF
    
    
    @array = []
    @conferir = []   # guardará os jogos que serão feitos, mas em um array
    sorteio = @aposta[:sorteio]
    apostas_desejadas = @aposta[:quantidadeJogos].to_i # LANÇAR AQUI QUANTAS APOSTAS VOCÊ DESEJA
    numeros_cada_aposta = @aposta[:quantidadeNumeros].to_i
    quantidade_apostadores = @aposta[:quantidadeApostadores2].to_i
    quotas_diferentes = @aposta[:bolaoQuotas]

    contador = 1
    @array_apostadores = []
    @array_pagamento = []
    @array_quotas = []
    while quantidade_apostadores >= contador
      apostador_symbol = ("apostador"+contador.to_s).to_sym
      if @aposta[apostador_symbol] != ""
        @array_apostadores << @aposta[apostador_symbol]
      else
        @array_apostadores << "____________________"
      end

      pagamento_symbol = ("pagamento"+contador.to_s).to_sym
      @array_pagamento << @aposta[pagamento_symbol]

      quotas_symbol = ("Quotas"+contador.to_s).to_sym
      if @aposta[quotas_symbol] == nil
        @array_quotas << 1
      else
        @array_quotas << @aposta[quotas_symbol]
      end

      contador += 1
    end



    if @aposta[:data] != ""
      @data =  "Sorteio: #{@aposta[:data].to_time.strftime('%d/%m/%Y')}"
    end

    if sorteio == "mega"
      (1...61).each { |n| @array << n}
      indice_corretor = 6
      modalidade = @mega
      @nome = 'Mega-sena'
    elsif sorteio == "dupla"
      (1...51).each { |n| @array << n}
      indice_corretor = 6
      modalidade = @dupla
      @nome = 'Dupla sena'
    elsif sorteio == "quina"
      (1...81).each { |n| @array << n}
      indice_corretor = 5
      modalidade = @quina
      @nome = 'Quina'
    elsif sorteio == "lotof"
      (1...26).each { |n| @array << n}
      indice_corretor = 15
      modalidade = @lotof
      @nome = 'Lotofácil'
    end



    while @conferir.count < apostas_desejadas
      if @array.count < numeros_cada_aposta
        @array = []
        if sorteio == "mega"
          (1...61).each { |n| @array << n}
        elsif sorteio == "dupla"
          (1...51).each { |n| @array << n}
        elsif sorteio == "quina"
          (1...81).each { |n| @array << n}
        elsif sorteio == "lotof"
          (1...26).each { |n| @array << n}
        end
      end

      aposta = @array.sample(numeros_cada_aposta).sort
      @conferir << aposta
      @conferir.uniq!
      for x in aposta
        @array.delete(x)
      end

    end

    if numeros_cada_aposta > 0
      valor_total = modalidade[:valor][numeros_cada_aposta - indice_corretor]*apostas_desejadas*100
      formato_money = Money.from_cents(valor_total, "BRL").format
      formato_brasil = formato_money.gsub!(".","*")
      if formato_brasil.include? ","
        formato_brasil.gsub!(",",".")
      end
      formato_brasil.gsub!("*",",")
      @valor = "Valor: #{formato_brasil}."

      @id_div_apostas = "apostas-geradas"

      chance = modalidade[:probabilidade][numeros_cada_aposta - indice_corretor]/apostas_desejadas
      @chance_printada = "Sua chance será de 1 em #{chance.to_s.reverse.scan(/.{1,3}/).join('.').reverse}."



      # RELATÓRIO SOBRE QUOTAS:
      quotas = 0
      for x in @array_quotas
        quotas += x.to_f
      end
      #TOTAL DE QUOTAS:
      if quotas.to_s.include? ".0"
        formato_brasil_quotas = quotas.to_s.gsub(".0","")
      else
        formato_brasil_quotas = quotas.to_s.gsub(".",",")
      end
      @total_quotas = "Total de quotas: #{formato_brasil_quotas}."
      
      #VALOR POR QUOTA:
      Money.default_infinite_precision = true # isso é para pegar todos os centavos e não arredondar, que estava acontecendo
      valor_temp_formato_money = (Money.from_cents(valor_total, "BRL") / Money.from_cents(quotas, "BRL"))
      valor_temp_formato_brasil = Money.from_cents(valor_temp_formato_money, "BRL").format.gsub!(".","*")
      if valor_temp_formato_brasil.include? ","
        valor_temp_formato_brasil.gsub!(",",".")
      end
      valor_temp_formato_brasil.gsub!("*",",")
      indice_da_virgula = valor_temp_formato_brasil.index(",") # isso para pegar só 2 casas decimais
      if valor_temp_formato_brasil[(indice_da_virgula + 3)] == "0" or valor_temp_formato_brasil[(indice_da_virgula + 3)] == nil # ou seja, se eu tenho um zero depois de duas casas da vírgula: ,__0
        @valor_por_quota = "Valor da quota: #{valor_temp_formato_brasil[0..(indice_da_virgula + 2)]}." # então eu pego só duas casas decimais depois da vírgula
      elsif valor_temp_formato_brasil[(indice_da_virgula + 3)].to_i > 5
        valor_temp_formato_brasil[(indice_da_virgula + 2)] = (valor_temp_formato_brasil[(indice_da_virgula + 2)].to_i + 1).to_s
        @valor_por_quota = "Valor da quota ( aproximado ): #{valor_temp_formato_brasil[0..(indice_da_virgula + 2)]}."
      else
        @valor_por_quota = "Valor da quota ( aproximado ): #{valor_temp_formato_brasil[0..(indice_da_virgula + 4)]}."
      end
    end
  end

  def sorte
    @quantidade_sorteios = Sorteio.all.size.to_s.reverse.scan(/.{1,3}/).join('.').reverse
    @array_sorte = []
    @conferir_sorte = []
    numeros = params[:meusNumeros]
    if numeros
      @numeros_da_sorte = numeros.split(/,/).map(&:to_i).sort # SE FUNCIONAR Isso cria um array com os números selecionados
      @sorteios = Sorteio.all
      @id_div_apostas = "apostas-geradas"
      # @sorteios.each do |sorteio|
      #   sorteio.numeros
      # end
      
    end
    # @teste = request[:meusNumeros].split(/,/).map(&:to_i).sort
    # @teste3 = params[:meusNumeros].present?
    
    # {"meusNumeros"=>"1,2,25,26,3,4"}
  end
  
  def conjuntos
    Money.locale_backend = nil # Estava dando informação de deprecado o fato de não haver apontamento da localização, mas, se isso não fosse importante, poderia ser usada essa linha de código

    @sorteios = Sorteio.all
    todos_numeros = []
    @mais_saem = []
    @menos_saem = []
    @media = []
    @media_mil = []
    @array17 = [] 
    @array13 = []
    @array10 = []
    
    # ARRAY DE 13 E DE 17
    contador = 1
    while contador < 18 
      numeros = @sorteios[- contador].numeros.split(/,/).map {|x| x.to_i} 
      for x in numeros 
        @array17 << x 
        if contador < 14 
          @array13 << x
          if contador < 11
            @array10 << x
          end 
        end     
      end   
      contador += 1 
    end
    @array17 = @array17.to_set.to_a.sort
    @array13 = @array13.to_set.to_a.sort
    @array10 = @array10.to_set.to_a.sort

    # OBTENDO NÚMEROS NA MÉDIA ÚLTIMOS 1000 JOGOS
    contador_mil = 1
    todos_numeros_mil_temp = []
    while contador_mil < 1001
      numeros_mil = @sorteios[- contador_mil].numeros.split(/,/).map {|x| x.to_i} 
      for x in numeros_mil 
        todos_numeros_mil_temp << x 
      end   
      contador_mil += 1 
    end
    hashruby_mil = todos_numeros_mil_temp.group_by { |v| v }.map { |k, v| [k.to_i, v.size] }.to_h
    hash_final_todos_numeros_mil = hashruby_mil.sort_by {|_key, value| value}.to_h
    array_ordenado_menos_saem_ate_mais_saem_mil = hash_final_todos_numeros_mil.keys
    @mais_saem_mil = array_ordenado_menos_saem_ate_mais_saem_mil.last(30).reverse # NÃO UTILIZADO!!!! começa do que mais sai
    @menos_saem_mil = array_ordenado_menos_saem_ate_mais_saem_mil.first(30) # NÃO UTILIZADO!!!!  começa do que menos sai
    contador_media_mil = 15
    while contador_media_mil < 45
      @media_mil << array_ordenado_menos_saem_ate_mais_saem_mil[contador_media_mil]
      contador_media_mil += 1
    end  



    # MAIS SAEM E MENOS SAEM (UTILIZADO PELO JAVA SCRIPT)
    @sorteios.each { |sorteio|
      array_temp = sorteio.numeros.split(/,/).map {|x| x.to_i}
      for x in array_temp
        todos_numeros << x
      end
    }

    hashruby = todos_numeros.group_by { |v| v }.map { |k, v| [k.to_i, v.size] }.to_h
    hash_final_todos_numeros = hashruby.sort_by {|_key, value| value}.to_h
    array_ordenado_menos_saem_ate_mais_saem = hash_final_todos_numeros.keys
    @mais_saem = array_ordenado_menos_saem_ate_mais_saem.last(30).reverse # começa do que mais sai
    @menos_saem = array_ordenado_menos_saem_ate_mais_saem.first(30) # começa do que menos sai
  
    contador_media = 15
    while contador_media < 45
      @media << array_ordenado_menos_saem_ate_mais_saem[contador_media]
      contador_media += 1
    end


  
    # DAQUI PARA BAIXO, SÓ COPIEI DA HOME VIEW
    @mega = MEGA

    if params[:meusNumeros2]
      @nome = "Mega-sena"
      # @conjunto_para_view = params[:meusNumeros2]
      @conjunto = params[:meusNumeros2].split(/,/).map(&:to_i).sort # SE FUNCIONAR Isso cria um array com os números selecionados
    end
    numeros_cada_aposta = params[:quantidadeNumeros2].to_i
    apostas_desejadas = params[:quantidadeJogos2].to_i # LANÇAR AQUI QUANTAS APOSTAS VOCÊ DESEJA
    indice_corretor = 6
    @conferir = []   # guardará os jogos que serão feitos, mas em um array
    # {"meusNumeros2"=>"47,48,49,50,51,52,53", "quantidadeNumeros2"=>"6", "quantidadeJogos2"=>"1", "controller"=>"pages", "action"=>"conjuntos"}



    # ESSE ALGORITMO ABAIXO  GERA AS APOSTAS COM REPETIÇÃO
    # while @conferir.count < apostas_desejadas
    #   aposta = @conjunto.sample(numeros_cada_aposta).sort
    #   @conferir << aposta
    #   @conferir.uniq!
    # end


    # ESSE ALGORITMO ABAIXO  GERA AS APOSTAS SEM REPETIÇÃO
    array_conjunto = []
    while @conferir.count < apostas_desejadas
      conjunto_apontado = params[:meusNumeros2].split(/,/).map(&:to_i).sort
      if array_conjunto.count < numeros_cada_aposta
        array_conjunto = conjunto_apontado
      end
      aposta = array_conjunto.sample(numeros_cada_aposta).sort
      @conferir << aposta
      @conferir.uniq!
      for x in aposta
        array_conjunto.delete(x)
      end
    end

 


    if numeros_cada_aposta > 0
      valor_total = @mega[:valor][numeros_cada_aposta - indice_corretor]*apostas_desejadas*100
      formato_money = Money.from_cents(valor_total, "BRL").format
      formato_brasil = formato_money.gsub!(".","*")
      if formato_brasil.include? ","
        formato_brasil.gsub!(",",".")
      end
      formato_brasil.gsub!("*",",")
      @valor = "Valor: #{formato_brasil}."

      @id_div_apostas = "apostas-geradas"

      # chance = @mega[:probabilidade][numeros_cada_aposta - indice_corretor]/apostas_desejadas
      # @chance_printada = "Sua chance será de 1 em #{chance.to_s.reverse.scan(/.{1,3}/).join('.').reverse}"

      # PARA CHECAR A PROBABILIDADE DE ACERTAR, VC DEVE ENTENDER QUE CONJUNTOS PEQUENOS (EX. 8 NÚMEROS) CONTERÃO APOSTAS REPETIDAS SE ELAS FORAM FEITAS COM, POR EXEMPLO, 7 NÚMEROS, ENTÃO, OPTEI POR PEGAR TODAS AS APOSTAS GERADAS, CONVERTENDO-AS EM APOSTAS DE 6 NÚMEROS E DEPOIS, EXCLUINDO AS REPETIÇÕES. DEPOIS, É SÓ DIVIDIR A PROBABILIDADE TOTAL MEGA PELO NÚMERO DE APOSTAS DE 6 NÚMEROS 
      conferir_apostas_convertidas_em_6numeros = []
      if numeros_cada_aposta == 6
        chance = @mega[:probabilidade][numeros_cada_aposta - indice_corretor]/apostas_desejadas
      elsif numeros_cada_aposta > 6 and apostas_desejadas == 1
        aposta_maior_que_6numeros_em_array_de_6numeros = aposta.combination(6).to_a
        for x in aposta_maior_que_6numeros_em_array_de_6numeros
          conferir_apostas_convertidas_em_6numeros << x
        end
        chance = @mega[:probabilidade][0]/conferir_apostas_convertidas_em_6numeros.to_set.size
      else
        @conferir.each { |aposta|  
          aposta_maior_que_6numeros_em_array_de_6numeros = aposta.combination(6).to_a
          for x in aposta_maior_que_6numeros_em_array_de_6numeros
            conferir_apostas_convertidas_em_6numeros << x
          end
        }
        chance = @mega[:probabilidade][0]/conferir_apostas_convertidas_em_6numeros.to_set.size
      end
      @chance_printada = "Sua chance será de 1 em #{chance.to_s.reverse.scan(/.{1,3}/).join('.').reverse}."






      # CALCULANDO ESTATÍSTICA PARA O CONJUNTO. PARA A APOSTA ESPECÍFICA DO CONJUNTO TIVE PROBLEMAS COM CONJUNTOS PEQUENOS, POIS PODEM HAVER APOSTAS REPETIDAS, O QUE TRAZ ERRO PARA A ESTATÍSTICA. ex. 1,2,3,4,5,6,7 e 1,2,3,4,5,6,8 trazem 1,2,3,4,5,6 como jogo repetido
      def fatorial(n)
        if n == 1
          return 1
        else
          return n*fatorial(n - 1)
        end
      end
      
      def probabilidade(conjunto, numeros_do_sorteio)
        prob_se_numeros_sorteados_no_conjunto = fatorial(conjunto)/(fatorial(numeros_do_sorteio)*fatorial(conjunto-numeros_do_sorteio))
        return prob_se_numeros_sorteados_no_conjunto
        # if numeros_por_aposta == numeros_do_sorteio
        #   quantidade_apostas_feitas_tomando_6x6 = total_de_apostas
        # else
        #   quantidade_apostas_feitas_tomando_6x6 = total_de_apostas*(fatorial(numeros_por_aposta)/(fatorial(numeros_do_sorteio)*fatorial(numeros_por_aposta-numeros_do_sorteio)))
        # end
        # return prob_se_numeros_sorteados_no_conjunto/quantidade_apostas_feitas_tomando_6x6
      end
      chance_no_escopo = probabilidade(@conjunto.size, 6)
      chance_mega = probabilidade(60, 6)
      @chance_escopo_printada = "A Mega possui #{chance_mega.to_s.reverse.scan(/.{1,3}/).join('.').reverse} de combinações, destas, #{chance_no_escopo.to_s.reverse.scan(/.{1,3}/).join('.').reverse} podem ser formadas com o seu conjunto da sorte."
    end






    
    
    # numeros = params[:meusNumeros2]
    # if numeros
    #   @numeros_da_sorte = numeros.split(/,/).map(&:to_i).sort # SE FUNCIONAR Isso cria um array com os números selecionados
      
    # end    
  end  

  def estatistica
    todos_sorteios = Sorteio.all
    todos_sorteios_em_array = []
    for x in todos_sorteios
      todos_sorteios_em_array << x[:numeros].split(/,/).map {|x| x.to_i}
    end

    @ultimo = todos_sorteios_em_array
    array60 = (1..60).to_a
    todos_duplas = array60.combination(2).to_a
    todos_ternos = array60.combination(3).to_a
    todos_quadras = array60.combination(4).to_a
    todos_quinas = array60.combination(5).to_a
    
    dicionario_duplas = {}
    dicionario_ternos = {}
    dicionario_quadras = {}
    dicionario_quinas = {}
    
    for x in todos_duplas
      dicionario_duplas[x] = 0
    end
    
    for x in todos_ternos
      dicionario_ternos[x] = 0
    end
    
    for x in todos_quadras
      dicionario_quadras[x] = 0
    end
    
    for x in todos_quinas
      dicionario_quinas[x] = 0
    end
    
    # # LANÇAR AQUI TODOS OS SORTEIOS
    todos_sorteios = @ultimo
    
    for sorteio in todos_sorteios
      novo_sorteio_em_duplas = sorteio.combination(2).to_a
      novo_sorteio_em_ternos = sorteio.combination(3).to_a
      novo_sorteio_em_quadras = sorteio.combination(4).to_a
      novo_sorteio_em_quinas = sorteio.combination(5).to_a
    
      for x in novo_sorteio_em_duplas
        if dicionario_duplas.key?(x)
          dicionario_duplas[x] += 1
        else
          dicionario_duplas[x] = 1 
        end
      end
      
      
      for x in novo_sorteio_em_ternos
        if dicionario_ternos.key?(x)
          dicionario_ternos[x] += 1
        else
          dicionario_ternos[x] = 1 
        end
      end
      
      for x in novo_sorteio_em_quadras
        if dicionario_quadras.key?(x)
          dicionario_quadras[x] += 1
        else
          dicionario_quadras[x] = 1 
        end
      end  
      
      for x in novo_sorteio_em_quinas
        if dicionario_quinas.key?(x)
          dicionario_quinas[x] += 1
        else
          dicionario_quinas[x] = 1 
        end
      end
    end
    
    @array_duplas_fim = []
    array_repeticoes_duplas_ultimos_5 = dicionario_duplas.values.to_set.to_a.sort.last(5)
    # DUPLAS:
    for x in array_repeticoes_duplas_ultimos_5.reverse
      @array_duplas_fim << "#{x} VEZES: #{dicionario_duplas.select{|k,v| v == x}.keys}"
    end

    # TERNOS:
    @array_ternos_fim = []
    array_repeticoes_ternos_ultimos_2 = dicionario_ternos.values.to_set.to_a.sort.last(2)
    for x in array_repeticoes_ternos_ultimos_2.reverse
      @array_ternos_fim << "#{x} VEZES: #{dicionario_ternos.select{|k,v| v == x}.keys}"
    end

    # QUADRAS
    @array_quadras_fim = []
    array_repeticoes_quadras_ultimos_2 = dicionario_quadras.values.to_set.to_a.sort.last(2)
    for x in array_repeticoes_quadras_ultimos_2.reverse
      @array_quadras_fim << "#{x} VEZES: #{dicionario_quadras.select{|k,v| v == x}.keys}"
    end

    # QUINAS: 
    @array_quinas_fim = []
    array_repeticoes_quinas_ultimos = dicionario_quinas.values.to_set.to_a.sort
    for x in array_repeticoes_quinas_ultimos
      if x > 1
        @array_quinas_fim << "#{x} VEZES: #{dicionario_quinas.select{|k,v| v == x}.keys}"
      end
    end

    # MAIS / MENOS SAEM:
    todos_numeros = []
    todos_sorteios_em_array.each { |sorteio|
      for x in sorteio
        todos_numeros << x
      end
    }

    hashruby = todos_numeros.group_by { |v| v }.map { |k, v| [k.to_i, v.size] }.to_h
    @hash_final_todos_numeros = hashruby.sort_by {|_key, value| value}.reverse.to_h
    # array_ordenado_menos_saem_ate_mais_saem = hash_final_todos_numeros.keys
    # @mais_saem = array_ordenado_menos_saem_ate_mais_saem.reverse # começa do que mais sai

    array_todos_numeros = []
    @sorteio_6x0_pares_impares = 0
    @sorteio_5x1_pares_impares = 0
    @sorteio_4x2_pares_impares = 0
    @sorteio_3x3_pares_impares = 0
    @sorteio_2x4_pares_impares = 0
    @sorteio_1x5_pares_impares = 0
    @sorteio_0x6_pares_impares = 0
    for cada_sorteio in @ultimo
      # CRIANDO ARRAY COM TODOS OS NÚMEROS
      for numero in cada_sorteio
        array_todos_numeros << numero
      end

      # CHECANDO CADA SORTEIO PARES E ÍMPARES (6x0; 5x1; etc. )
      if cada_sorteio.count { | item | item.even? } == 6
        @sorteio_6x0_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 5
        @sorteio_5x1_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 4
        @sorteio_4x2_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 3
        @sorteio_3x3_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 2
        @sorteio_2x4_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 1
        @sorteio_1x5_pares_impares += 1
      elsif cada_sorteio.count { | item | item.even? } == 0
        @sorteio_0x6_pares_impares += 1
      end      
    end

    # PARES E ÍMPARES
    # @contador_par = 0
    # @contador_impar = 0
    # for x in array_todos_numeros
    #   if x % 2 == 0
    #       @contador_par += 1
    #   else
    #       @contador_impar += 1
    #   end
    # end
    # PARES E ÍMPARES TOTAL
    @pares = array_todos_numeros.count { | item | item.even? }
    @impares = array_todos_numeros.count { | item | item.odd? }

    # QUADRANTES
    quad1 = [1, 2, 3, 4, 5, 11, 12, 13, 14, 15, 21, 22, 23, 24, 25]
    quad2 = [6, 7, 8, 9, 10, 16, 17, 18, 19, 20, 26, 27, 28, 29, 30]
    quad3 = [31, 32, 33, 34, 35, 41, 42, 43, 44, 45, 51, 52, 53, 54, 55]
    quad4 = [36, 37, 38, 39, 40, 46, 47, 48, 49, 50, 56, 57, 58, 59, 60]
    @quadrante1 = 0
    @quadrante2 = 0
    @quadrante3 = 0
    @quadrante4 = 0

    # COLUNAS E LINHAS
    col1 = [1,11,21,31,41,51]
    col2 = [2,12,22,32,42,52]
    col3 = [3,13,23,33,43,53]
    col4 = [4,14,24,34,44,54]
    col5 = [5,15,25,35,45,55]
    col6 = [6,16,26,36,46,56]
    col7 = [7,17,27,37,47,57]
    col8 = [8,18,28,38,48,58]
    col9 = [9,19,29,39,49,59]
    col10 = [10,20,30,40,50,60]
    @coluna1 = 0
    @coluna2 = 0
    @coluna3 = 0
    @coluna4 = 0
    @coluna5 = 0
    @coluna6 = 0
    @coluna7 = 0
    @coluna8 = 0
    @coluna9 = 0
    @coluna10 = 0
    
    @linha1_do_1_ao_10 = 0
    @linha2_do_11_ao_20 = 0
    @linha3_do_21_ao_30 = 0
    @linha4_do_31_ao_40 = 0
    @linha5_do_41_ao_50 = 0
    @linha6_do_51_ao_60 = 0

    for numero in array_todos_numeros
      #LINHAS
      if numero < 11
        @linha1_do_1_ao_10 += 1
      elsif numero < 21
        @linha2_do_11_ao_20 += 1
      elsif numero < 31
        @linha3_do_21_ao_30 += 1
      elsif numero < 41
        @linha4_do_31_ao_40 += 1
      elsif numero < 51
        @linha5_do_41_ao_50 += 1
      else
        @linha6_do_51_ao_60 += 1
      end

      # COLUNAS
      if col1.include?(numero)
        @coluna1 += 1
      elsif col2.include?(numero)
        @coluna2 += 1
      elsif col3.include?(numero)
        @coluna3 += 1
      elsif col4.include?(numero)
        @coluna4 += 1
      elsif col5.include?(numero)
        @coluna5 += 1
      elsif col6.include?(numero)
        @coluna6 += 1
      elsif col7.include?(numero)
        @coluna7 += 1
      elsif col8.include?(numero)
        @coluna8 += 1
      elsif col9.include?(numero)
        @coluna9 += 1
      elsif col10.include?(numero)
        @coluna10 += 1
      end

      # QUADRANTES TODOS OS NÚMEROS
      if quad1.include?(numero)
        @quadrante1 += 1
      elsif quad2.include?(numero)
        @quadrante2 += 1
      elsif quad3.include?(numero)
        @quadrante3 += 1
      elsif quad4.include?(numero)
        @quadrante4 += 1
      end
    end

    
    @seis_mesmo_quadrante = 0
    @cinco_mesmo_quadrante = 0
    @quatro_mesmo_quadrante = 0
    @tres_mesmo_quadrante = 0
    for cada_sorteio in @ultimo
      if ((cada_sorteio & quad1).size == 6) or ((cada_sorteio & quad2).size == 6) or ((cada_sorteio & quad3).size == 6) or ((cada_sorteio & quad4).size == 6)
        @seis_mesmo_quadrante += 1
      elsif ((cada_sorteio & quad1).size == 5) or ((cada_sorteio & quad2).size == 5) or ((cada_sorteio & quad3).size == 5) or ((cada_sorteio & quad4).size == 5)
        @cinco_mesmo_quadrante += 1
      elsif ((cada_sorteio & quad1).size == 4) or ((cada_sorteio & quad2).size == 4) or ((cada_sorteio & quad3).size == 4) or ((cada_sorteio & quad4).size == 4)
        @quatro_mesmo_quadrante += 1
      elsif ((cada_sorteio & quad1).size == 3) or ((cada_sorteio & quad2).size == 3) or ((cada_sorteio & quad3).size == 3) or ((cada_sorteio & quad4).size == 3)
        @tres_mesmo_quadrante += 1
      end
    end
    
    # DICIONÁRIO DE QUADRANTES (ESTÁ ATRASANDO O PROCESSAMENTO)
    array_todos_quadrantes = []
    for cada_sorteio in @ultimo
      array_todos_quadrantes << [(cada_sorteio & quad1).size, (cada_sorteio & quad2).size, (cada_sorteio & quad3).size, (cada_sorteio & quad4).size].sort.reverse
    end
    set_com_array_todos_quadrantes = array_todos_quadrantes.to_set
    @dicionario_quadrantes = {}
    for x in set_com_array_todos_quadrantes
      @dicionario_quadrantes[x] = array_todos_quadrantes.count(x) 
    end
  end


# // {"sorteio"=>"mega",
#   //  "quantidadeNumeros"=>"6",
#   //  "quantidadeJogos"=>"2",
# {"authenticity_token"=>"vy8YC/oWh4Bq5ZaBHU+talKy5cVX8p0TeDqMc8sZcHJkjYuD5L9e2+f3mwOWvzAva5oVDx2Ruy/Hgi1SwJ4qUQ==",
#   "sorteio"=>"mega",
#   "quantidadeNumeros"=>"6",
#   "quantidadeJogos"=>"5",
#   "bolao"=>"sim",
#   "quantidadeApostadores2"=>"2",
#   "data"=>"",
#   "bolaoQuotas"=>"sim",
#   "apostador1"=>"Gretchen",
#   "pagamento1"=>"on",
#   "Quotas1"=>"1.5",
#   "apostador2"=>"Eduardo",
#   "Quotas2"=>"1",
#   "quantidadeQuotas"=>"1",
#   "cota1"=>"0",
#   "cota2"=>"0",
#   "cota3"=>"0"}
end
