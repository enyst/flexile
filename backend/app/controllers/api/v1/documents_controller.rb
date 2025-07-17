# frozen_string_literal: true

class Api::V1::DocumentsController < Api::V1::ApiController
  before_action :set_document, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @documents = policy_scope(Document)
    render json: @documents
  end

  def show
    authorize @document
    render json: @document
  end

  def create
    @document = Document.new(document_params)
    authorize @document

    if @document.save
      render json: @document, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @document
    if @document.update(document_params)
      render json: @document
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @document
    @document.destroy
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :file, :company_id)
  end
end
