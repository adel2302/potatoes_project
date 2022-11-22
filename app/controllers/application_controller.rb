# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  def authorize_request
    token = header_auth
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private

  def header_auth
    request.headers['Authorization']&.split(' ')&.last
  end
end
