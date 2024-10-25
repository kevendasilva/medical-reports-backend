# frozen_string_literal: true

require 'hexapdf'
require 'stringio'

class LaudosController < ApplicationController
  before_action :set_laudo, only: %i[show update destroy]

  # GET /laudos
  def index
    @q = Laudo.ransack(params[:q])

    if params.key?(:t) && params[:t].blank?
      render json: { error: 'Termo da busca não informado' }, status: :bad_request
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
    uploaded_file = params[:arquivo]

    if uploaded_file.nil?
      render json: { error: 'Nenhum arquivo foi enviado' }, status: :unprocessable_entity
      return
    end

    begin
      file_io = uploaded_file.tempfile

      pdf_document = HexaPDF::Document.open(file_io)

      unless pdf_document.signatures.any?
        render json: { error: 'O arquivo enviado não está assinado' }, status: :unprocessable_entity
        return
      end
    rescue StandardError => e
      render json: { error: "Erro ao processar PDF: #{e.message}" }, status: :unprocessable_entity
      return
    end

    process_file(@laudo, uploaded_file)

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
