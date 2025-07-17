# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Documents', type: :system do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:company_administrator) { create(:company_administrator, company:, user:) }
  let(:headers) { { 'Authorization' => "Bearer \#{user.clerk_id}" } }

  describe 'GET /api/v1/documents' do
    it 'returns a list of documents' do
      create_list(:document, 3, company:)
      get '/api/v1/documents', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/documents/:id' do
    it 'returns a single document' do
      document = create(:document, company:)
      get "/api/v1/documents/\#{document.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(document.id)
    end
  end

  describe 'POST /api/v1/documents' do
    it 'creates a new document' do
      document_params = attributes_for(:document, company_id: company.id)
      post '/api/v1/documents', params: { document: document_params }, headers: headers
      expect(response).to have_http_status(:created)
      expect(Document.count).to eq(1)
    end
  end

  describe 'PUT /api/v1/documents/:id' do
    it 'updates an existing document' do
      document = create(:document, company:)
      put "/api/v1/documents/\#{document.id}", params: { document: { name: 'New Name' } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(document.reload.name).to eq('New Name')
    end
  end

  describe 'DELETE /api/v1/documents/:id' do
    it 'deletes a document' do
      document = create(:document, company:)
      delete "/api/v1/documents/\#{document.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Document.count).to eq(0)
    end
  end
end
