# frozen_string_literal: true

class Api::V1::InvoicesController < Api::V1::ApiController
  before_action :set_invoice, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @invoices = policy_scope(Invoice)
    render json: InvoicePresenter.new(@invoices).present
  end

  def show
    authorize @invoice
    render json: InvoicePresenter.new(@invoice).present
  end

  def create
    authorize Invoice
    result = CreateOrUpdateInvoiceService.new(
      params: invoice_params,
      user: Current.user,
      company: Current.company
    ).process

    if result[:success]
      render json: InvoicePresenter.new(result[:invoice]).present, status: :created
    else
      render json: { error_message: result[:error_message] }, status: :unprocessable_entity
    end
  end

  def update
    authorize @invoice
    result = CreateOrUpdateInvoiceService.new(
      params: invoice_params,
      user: Current.user,
      company: Current.company,
      invoice: @invoice
    ).process

    if result[:success]
      render json: InvoicePresenter.new(result[:invoice]).present
    else
      render json: { error_message: result[:error_message] }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @invoice
    @invoice.destroy
    head :no_content
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:number, :date, :due_date, :amount, :status, :company_id, :contact_id)
  end
end
