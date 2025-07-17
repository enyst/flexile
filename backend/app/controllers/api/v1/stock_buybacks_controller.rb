# frozen_string_literal: true

class Api::V1::StockBuybacksController < Api::V1::ApiController
  before_action :set_stock_buyback, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @stock_buybacks = policy_scope(EquityBuyback)
    render json: @stock_buybacks
  end

  def show
    authorize @stock_buyback
    render json: @stock_buyback
  end

  def create
    @stock_buyback = EquityBuyback.new(stock_buyback_params)
    authorize @stock_buyback

    if @stock_buyback.save
      render json: @stock_buyback, status: :created
    else
      render json: @stock_buyback.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @stock_buyback
    if @stock_buyback.update(stock_buyback_params)
      render json: @stock_buyback
    else
      render json: @stock_buyback.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @stock_buyback
    @stock_buyback.destroy
  end

  private

  def set_stock_buyback
    @stock_buyback = EquityBuyback.find(params[:id])
  end

  def stock_buyback_params
    params.require(:stock_buyback).permit(:price, :quantity, :company_id)
  end
end
