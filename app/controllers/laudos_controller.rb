class LaudosController < ApplicationController
  before_action :set_laudo, only: %i[show update destroy]

  # GET /laudos
  def index
    @q = Laudo.ransack(params[:q])

    if params.key?(:t) && params[:t].blank?
      render json: { error: 'Termo de busca não informado' }, status: :bad_request
    elsif params.key?(:t) && params[:t].present?
      @q.texto_cont = params[:t]
      @laudos = @q.result(distinct: true).order(created_at: :desc).limit(50)
      render 'laudos/index', formats: :json
    else
      @laudos = Laudo.order(created_at: :desc).limit(50)
      render 'laudos/index', formats: :json
    end
  end

  # GET /laudos/1
  def show
    render template: 'laudos/show', formats: :json
  end

  # POST /laudos
  def create
    @laudo = Laudo.new(laudo_params)
    process_file(@laudo, params[:arquivo])

    if @laudo.save
      render json: @laudo, status: :created, location: @laudo
    else
      render json: @laudo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /laudos/1
  def update
    process_file(@laudo, params[:arquivo])

    if @laudo.update(laudo_params)
      render json: @laudo
    else
      render json: @laudo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /laudos/1
  def destroy
    @laudo.destroy!
  end

  private

  def process_file(laudo, uploaded_file)
    return if uploaded_file.nil?

    base64_content = Base64.strict_encode64(uploaded_file.read)
    laudo.arquivo = base64_content
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_laudo
    @laudo = Laudo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def laudo_params
    params.permit(:data, :crm, :texto, :arquivo)
  end
end
