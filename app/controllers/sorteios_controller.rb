class SorteiosController < ApplicationController
  

  def index
    # @sorteios = Sorteio.all
    @sorteios = policy_scope(Sorteio)
  end
  
  def show
    @sorteio = Sorteio.find(params[:id])
    authorize @sorteio  
 
  end

  def new
    @sorteio = Sorteio.new # Needed to instantiate the form_with
    authorize @sorteio
  end

  
  def create

    @sorteio = Sorteio.new()

    @sorteio.concurso = params[:sorteio][:concurso].to_i
    @sorteio.data = params[:sorteio][:data].to_time.strftime('%d/%m/%Y')
    @sorteio.numeros = params[:sorteio][:numeros]

    authorize @sorteio

    @sorteio.save
    # No need for app/views/sorteios/create.html.erb
    redirect_to sorteio_path(@sorteio)
  end
  
  def edit
    @sorteio = Sorteio.find(params[:id])
    authorize @sorteio
  end

  def update
    @sorteio = Sorteio.find(params[:id])
    authorize @sorteio
    @sorteio.update({concurso: params[:sorteio][:concurso].to_i, data: params[:sorteio][:data].to_time.strftime('%d/%m/%Y'), numeros: params[:sorteio][:numeros]})

    # No need for app/views/sorteios/update.html.erb
    redirect_to sorteio_path(@sorteio)
  end

  def destroy
    
    @sorteio = Sorteio.find(params[:id])
    authorize @sorteio
    @sorteio.destroy
    # No need for app/views/sorteios/destroy.html.erb
    redirect_to sorteios_path, status: :see_other
  end

  # private
  
  # def sorteio_params
  #   params.require(:sorteio).permit(:concurso, :data, :numeros)
  #   # params[:sorteio][:data] = Time.strptime(params[:sorteio][:data], "%Y-%m-%d").strftime("%d/%m/%Y")  
  #   # params[:sorteio][:data] = params[:sorteio][:data].to_time.strftime('%d/%m/%Y')
  # end


end
