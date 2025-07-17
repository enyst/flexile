# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Dividends', type: :system do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:company_administrator) { create(:company_administrator, company:, user:) }
  let(:headers) { { 'Authorization' => "Bearer \#{user.clerk_id}" } }

  describe 'GET /api/v1/dividends' do
    it 'returns a list of dividends' do
      create_list(:dividend, 3, company:)
      get '/api/v1/dividends', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/dividends/:id' do
    it 'returns a single dividend' do
      dividend = create(:dividend, company:)
      get "/api/v1/dividends/\#{dividend.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(dividend.id)
    end
  end

  describe 'POST /api/v1/dividends' do
    it 'creates a new dividend' do
      dividend_params = attributes_for(:dividend, company_id: company.id)
      post '/api/v1/dividends', params: { dividend: dividend_params }, headers: headers
      expect(response).to have_http_status(:created)
      expect(Dividend.count).to eq(1)
    end
  end

  describe 'PUT /api/v1/dividends/:id' do
    it 'updates an existing dividend' do
      dividend = create(:dividend, company:)
      put "/api/v1/dividends/\#{dividend.id}", params: { dividend: { amount: 1000 } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(dividend.reload.amount).to eq(1000)
    end
  end

  describe 'DELETE /api/v1/dividends/:id' do
    it 'deletes a dividend' do
      dividend = create(:dividend, company:)
      delete "/api/v1/dividends/\#{dividend.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Dividend.count).to eq(0)
    end
  end
end
