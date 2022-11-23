# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StockPrices', type: :request do
  before do
    user = FactoryBot.create(:user)
    @token = login(user)

    price = 121
    4.times do
      Timecop.freeze(Time.now - 2.day) do
        FactoryBot.create(:stock_price, value: price)
      end
      price += 1
      sleep 0.1
    end

    4.times do
      Timecop.freeze(Time.now - 1.day) do
        FactoryBot.create(:stock_price, value: price)
      end
      price += 1
      sleep 0.1
    end
  end

  let(:valid_headers) do
    { Authorization: @token }
  end

  let(:valid_attribute) do
    { day: (Time.now - 2.day).strftime('%d/%m/%Y') }
  end

  let(:valid_empty_attribute) do
    { day: '' }
  end

  let(:market_closed) do
    { day: '01/01/1900' }
  end

  let(:invalid_attribute) do
    { day: 'Select * from ....' }
  end

  describe 'GET /search' do
    context 'with valid parameter' do
      it 'returns http success' do
        get '/stock_prices/search', headers: valid_headers, params: { stock_price: valid_attribute }
        expect(response).to have_http_status(:success)
      end

      it 'returns array correctly ordered' do
        get '/stock_prices/search', headers: valid_headers, params: { stock_price: valid_attribute }
        rsp = JSON.parse response.body
        expect(rsp.first['time']).to be > rsp.last['time']
      end

      it 'returns array of yesterday stock price when day missing' do
        get '/stock_prices/search', headers: valid_headers, params: { stock_price: valid_empty_attribute }
        rsp = JSON.parse response.body
        rsp_first_date = Date.parse(rsp.first['time']).strftime('%d/%m/%Y')
        expected_first_date = (Time.now - 1.day).strftime('%d/%m/%Y')
        expect(rsp_first_date).to eq expected_first_date
      end

      it 'returns message when data missing' do
        get '/stock_prices/search', headers: valid_headers, params: { stock_price: market_closed }
        rsp = JSON.parse response.body
        expect(rsp['message']).to eq('Data unavailable for this day')
      end
    end

    context 'with invalid parameter' do
      it 'returns a json error when attribute format is wrong' do
        get '/stock_prices/search', headers: valid_headers, params: { stock_price: invalid_attribute }
        rsp = JSON.parse response.body
        expect(response.status).to eq(422)
        expect(rsp['error']).to eq('Format must be dd/mm/yyyy')
      end
    end
  end

  describe 'GET /simulation' do
    context 'with valid parameter' do
      it 'returns http success' do
        get '/stock_prices/simulation', headers: valid_headers, params: { stock_price: valid_attribute }
        expect(response).to have_http_status(:success)
      end

      it 'returns the right gain' do
        get '/stock_prices/simulation', headers: valid_headers, params: { stock_price: valid_attribute }
        rsp = JSON.parse response.body
        expect(rsp['gain']).to eq('300.0€')
      end

      it 'returns 0€ when stock price not exist for a particular day' do
        get '/stock_prices/simulation', headers: valid_headers, params: { stock_price: { day: '01/01/1900' } }
        rsp = JSON.parse response.body
        expect(rsp['gain']).to eq('0.0€')
      end
    end
  end
end
