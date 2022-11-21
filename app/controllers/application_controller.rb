# frozen_string_literal: true
require 'net/http'

class ApplicationController < ActionController::API
  before_action :require_jwt

  def require_jwt
    token = request.headers['HTTP_AUTHORIZATION']
    head :forbidden unless token
    head :forbidden unless valid_token(token)
  end

  private

  def valid_token(token)
    return false unless token

    token.gsub!('Bearer ', '')
    begin
      okta_keys_url = "#{ENV['ISSUER']}/v1/keys"
      jwks_raw = Net::HTTP.get URI(okta_keys_url)
      jwk_keys = Array(JSON.parse(jwks_raw, symbolize_names: true)[:keys])
      token_payload = JWT.decode(token, nil, true, { algorithms: ['RS256'], jwks: { keys: jwk_keys } })

      p token_payload

      return true
    rescue JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end
    false
  end
end
