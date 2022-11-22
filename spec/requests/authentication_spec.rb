# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'POST /login' do
    context 'be valid' do
      it 'with the right arguments' do
        post login_url, params: { login: {
          login: @user.login,
          password: @user.password
        } }
        expect(JSON.parse(response.body)['token'].present?).to eq(true)
      end
    end
    context 'not be valid' do
      it 'login is false' do
        post login_url, params: { login: {
          login: 'fake',
          password: @user.password
        } }
        expect(JSON.parse(response.body)['error']).to eq('unauthorized')
      end

      it 'login is missing' do
        post login_url, params: { login: {
          login: '',
          password: @user.password
        } }
        expect(JSON.parse(response.body)['error']).to eq('unauthorized')
      end

      it 'password is false' do
        post login_url, params: { login: {
          login: @user.login,
          password: 'fake'
        } }
        expect(JSON.parse(response.body)['error']).to eq('unauthorized')
      end

      it 'password is missing' do
        post login_url, params: { login: {
          login: @user.login,
          password: ''
        } }
        expect(JSON.parse(response.body)['error']).to eq('unauthorized')
      end
    end
  end
end
