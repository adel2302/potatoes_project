# frozen_string_literal: true

module Authenticate
  def login(user)
    post login_url, params: { login: {
      login: user.login,
      password: user.password
    } }
    @token = JSON.parse(response.body)['token']
  end
end
