# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @stock_price = FactoryBot.create(:stock_price)
    @token = login(@user)
  end

  let(:valid_headers) do
    { Authorization: @token }
  end

  describe 'POST /create' do
    describe 'BUY' do
      let(:valid_attribute) do
        { side: 0,
          quantity: 1.0 }
      end
      context 'with valid parameters and limit not exceed' do
        it 'creates a new Order' do
          expect do
            post orders_url,
                 params: { order: valid_attribute },
                 headers: valid_headers, as: :json
          end.to change(Order, :count).by(1)
        end
      end

      context 'when the daily limit is exceeded' do
        before do
          FactoryBot.create(:order, side: 0, quantity: 100, user_id: @user.id, stock_price_id: @stock_price.id)
        end
        it 'does not create a new Order' do
          post orders_url,
               params: { order: valid_attribute },
               headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end

      describe 'SELL' do
        before do
          @user.wallets.currency_ptt.first.update(available: 5.0)
        end

        let(:valid_attribute) do
          { side: 1,
            quantity: 1.0 }
        end

        context 'with valid parameters and limit not exceed' do
          it 'creates a new Order' do
            expect do
              post orders_url,
                   params: { order: valid_attribute },
                   headers: valid_headers, as: :json
            end.to change(Order, :count).by(1)
          end
        end

        context 'when quatity order exceed ptt in wallet' do
          it 'creates a new Order' do
            valid_attribute[:quantity] = 100
            post orders_url,
                 params: { order: valid_attribute },
                 headers: valid_headers, as: :json
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
          end
        end
      end
    end
  end
end
