# frozen_string_literal: true

class Api::V1::InvoicesController < Api::V1::ApiController
  before_action :set_invoice, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @invoices = policy_scope(Invoice)
    render json: @invoices
  end

  def show
    authorize @invoice
    render json: @invoice
  end

  def create
    @invoice = Invoice.new(invoice_params)
    authorize @invoice

    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @invoice
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @invoice
    @invoice.destroy
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:number, :date, :due_date, :amount, :status, :company_id, :contact_id)
  end
end
