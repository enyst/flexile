# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Invoices', type: :system do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:company_administrator) { create(:company_administrator, company:, user:) }
  let(:headers) { { 'Authorization' => "Bearer \#{user.clerk_id}" } }

  describe 'GET /api/v1/invoices' do
    it 'returns a list of invoices' do
      create_list(:invoice, 3, company:)
      get '/api/v1/invoices', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/invoices/:id' do
    it 'returns a single invoice' do
      invoice = create(:invoice, company:)
      get "/api/v1/invoices/\#{invoice.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(invoice.external_id)
    end
  end

  describe 'POST /api/v1/invoices' do
    it 'creates a new invoice' do
      invoice_params = attributes_for(:invoice, company_id: company.id)
      post '/api/v1/invoices', params: { invoice: invoice_params }, headers: headers
      expect(response).to have_http_status(:created)
      expect(Invoice.count).to eq(1)
    end
  end

  describe 'PUT /api/v1/invoices/:id' do
    it 'updates an existing invoice' do
      invoice = create(:invoice, company:)
      put "/api/v1/invoices/\#{invoice.id}", params: { invoice: { status: 'paid' } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(invoice.reload.status).to eq('paid')
    end
  end

  describe 'DELETE /api/v1/invoices/:id' do
    it 'deletes an invoice' do
      invoice = create(:invoice, company:)
      delete "/api/v1/invoices/\#{invoice.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Invoice.count).to eq(0)
    end
  end
end
