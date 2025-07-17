# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::StockBuybacks', type: :system do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:company_administrator) { create(:company_administrator, company:, user:) }
  let(:headers) { { 'Authorization' => "Bearer \#{user.clerk_id}" } }

  describe 'GET /api/v1/stock_buybacks' do
    it 'returns a list of stock_buybacks' do
      create_list(:equity_buyback, 3, company:)
      get '/api/v1/stock_buybacks', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/stock_buybacks/:id' do
    it 'returns a single stock_buyback' do
      stock_buyback = create(:equity_buyback, company:)
      get "/api/v1/stock_buybacks/\#{stock_buyback.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(stock_buyback.id)
    end
  end

  describe 'POST /api/v1/stock_buybacks' do
    it 'creates a new stock_buyback' do
      stock_buyback_params = attributes_for(:equity_buyback, company_id: company.id)
      post '/api/v1/stock_buybacks', params: { stock_buyback: stock_buyback_params }, headers: headers
      expect(response).to have_http_status(:created)
      expect(EquityBuyback.count).to eq(1)
    end
  end

  describe 'PUT /api/v1/stock_buybacks/:id' do
    it 'updates an existing stock_buyback' do
      stock_buyback = create(:equity_buyback, company:)
      put "/api/v1/stock_buybacks/\#{stock_buyback.id}", params: { stock_buyback: { price: 1000 } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(stock_buyback.reload.price).to eq(1000)
    end
  end

  describe 'DELETE /api/v1/stock_buybacks/:id' do
    it 'deletes a stock_buyback' do
      stock_buyback = create(:equity_buyback, company:)
      delete "/api/v1/stock_buybacks/\#{stock_buyback.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(EquityBuyback.count).to eq(0)
    end
  end
end
