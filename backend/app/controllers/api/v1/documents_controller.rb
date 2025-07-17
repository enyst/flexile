# frozen_string_literal: true

class Api::V1::DocumentsController < Api::V1::ApiController
  before_action :set_document, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @documents = policy_scope(Document)
    render json: DocumentPresenter.new(@documents).present
  end

  def show
    authorize @document
    render json: DocumentPresenter.new(@document).present
  end

  def create
    authorize Document
    @document = Document.new(document_params)

    if @document.save
      render json: DocumentPresenter.new(@document).present, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @document
    if @document.update(document_params)
      render json: DocumentPresenter.new(@document).present
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @document
    @document.destroy
    head :no_content
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :file, :company_id)
  end
end
