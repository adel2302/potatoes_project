# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) do
    {
      login: Faker::Lorem.characters(number: 6..15),
      password: Faker::Lorem.characters(number: 6..15)
    }
  end

  let(:invalid_attributes) do
    {
      login: '',
      password: ''
    }
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url,
               params: { user: valid_attributes }, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post users_url,
             params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')

        rsp_body = JSON.parse response.body
        expect(rsp_body).to have_key('id')
        expect(rsp_body).to have_key('login')

        expect(rsp_body).to_not have_key('password_digest')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url,
               params: { user: invalid_attributes }, as: :json
        end.not_to change(User, :count)
      end

      it 'renders a JSON response with errors for the new user' do
        post users_url,
             params: { user: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end
end
