# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::People', type: :system do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:company_administrator) { create(:company_administrator, company:, user:) }
  let(:headers) { { 'Authorization' => "Bearer \#{user.clerk_id}" } }

  describe 'GET /api/v1/people' do
    it 'returns a list of people' do
      create_list(:user, 3, company:)
      get '/api/v1/people', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/people/:id' do
    it 'returns a single person' do
      person = create(:user, company:)
      get "/api/v1/people/\#{person.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(person.external_id)
    end
  end

  describe 'POST /api/v1/people' do
    it 'creates a new person' do
      person_params = attributes_for(:user, company_id: company.id)
      post '/api/v1/people', params: { person: person_params }, headers: headers
      expect(response).to have_http_status(:created)
      expect(User.count).to eq(1)
    end
  end

  describe 'PUT /api/v1/people/:id' do
    it 'updates an existing person' do
      person = create(:user, company:)
      put "/api/v1/people/\#{person.id}", params: { person: { first_name: 'John' } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(person.reload.first_name).to eq('John')
    end
  end

  describe 'DELETE /api/v1/people/:id' do
    it 'deletes a person' do
      person = create(:user, company:)
      delete "/api/v1/people/\#{person.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(User.count).to eq(0)
    end
  end
end
