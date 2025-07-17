# frozen_string_literal: true

class Api::V1::DividendsController < Api::V1::ApiController
  before_action :set_dividend, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @dividends = policy_scope(Dividend)
    render json: @dividends
  end

  def show
    authorize @dividend
    render json: @dividend
  end

  def create
    @dividend = Dividend.new(dividend_params)
    authorize @dividend

    if @dividend.save
      render json: @dividend, status: :created
    else
      render json: @dividend.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @dividend
    if @dividend.update(dividend_params)
      render json: @dividend
    else
      render json: @dividend.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @dividend
    @dividend.destroy
  end

  private

  def set_dividend
    @dividend = Dividend.find(params[:id])
  end

  def dividend_params
    params.require(:dividend).permit(:amount, :pay_date, :company_id)
  end
end
