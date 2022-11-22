# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Wallets', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @token = login(@user)
  end

  let(:valid_attributes) do
    { currency: 0 }
  end

  let(:invalid_attributes) do
    { currency: nil }
  end

  let(:valid_headers) do
    { Authorization: @token }
  end

  describe 'POST /create' do
    context 'with valid parameter' do
      it 'renders a JSON response with the new Wallet' do
        post wallets_url,
             params: { wallet: valid_attributes },
             headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end

      it 'renders a JSON response with errors Wallet exist with same currency' do
        @user.wallets.create(currency: 0)

        post wallets_url,
             params: { wallet: valid_attributes },
             headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid parameter' do
      it 'renders a JSON response with errors for the new Wallet' do
        post wallets_url,
             params: { wallet: invalid_attributes },
             headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end
end
