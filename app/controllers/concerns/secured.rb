# frozen_string_literal: true

# typed: true

require 'jwt'
require 'net/http'
require 'sorbet-runtime'

module Secured
  extend ActiveSupport::Concern
  extend T::Sig

  module RoleMethods
    extend T::Sig

    sig { params(roles: T::Array[Integer]).void }
    def requires_roles(roles:)
      @required_roles = roles.map {|role| Protos::Actor::Role.lookup(role)}
    end

    sig { returns(T::Array[Protos::Actor::Role]) }
    def required_roles
      @required_roles || []
    end
  end

  sig { params(base: T.class_of(ActionController::API)).void }
  def self.included(base)
    # Define the options for JWT verification
    base.before_action :valid_token?
    base.before_action :has_role?
    base.extend(RoleMethods)
  end

  sig { returns(Protos::Actor::User) }
  def valid_token?
    options = {
      algorithm: 'RS256',
      verify_iss: true,
      iss: 'https://yourdomain.auth0.com/',
      verify_aud: true,
      aud: 'your-audience'
    }

    decoded = verify_jwt(token: extract_token_from_header, options: options).first || {"failure" => "Invalid Token"}
    @current_user = Protos::Actor::User.new(identity: decoded["sub"], role: role_mapper(role: T.must(decoded["Role"])))
  end

  sig { returns(T::Boolean) }
  def has_role?
    if T.unsafe(self).class.required_roles.length > 0
      unless T.unsafe(self).class.required_roles.include?(@current_user.role)
        invalid_authentication
        false
      end
    else
      invalid_authentication
      false
    end
    true
  end

  private

  sig { params(token: String, options: T::Hash[Symbol, T.any(String, T::Boolean)]).returns(T::Array[T::Hash[String, String]]) }
  # Verify the JWT token
  def verify_jwt(token:, options:)
    ## Not using a live IDP
    # jwks_uri = 'https://yourdomain.auth0.com/.well-known/jwks.json'
    # jwks_response = Net::HTTP.get(URI(jwks_uri))
    # jwks_keys = Array(JSON.parse(jwks_response)['keys'])
    # jwk = jwks_keys.find do |key|
    #   key['kid'] == JWT.decode(token, nil, false)[1]['kid']
    # end

    # if jwk.nil?
    #   raise JWT::DecodeError, 'Unable to find a matching key in the JWKS endpoint'
    # end

    # key = OpenSSL::X509::Certificate.new(Base64.decode64(jwk['x5c'].first)).public_key
    JWT.decode(token, nil, false)
  end

  sig { returns(String) }
  def extract_token_from_header
    auth_header = request.headers['Authorization']
    if auth_header.nil?
      token = JWT.encode({ sub: '12345', Role: 'scientist' }, nil, 'none')
     # invalid_authentication
    else
      auth_header.split(' ').last
    end
  end

  sig { params(role: String).returns(Integer) }
  def role_mapper(role:)
    mapped = case role.downcase
      when 'builder'
        Protos::Actor::Role::ROLE_BUILDER
      when 'scientist'
        Protos::Actor::Role::ROLE_SCIENTIST
      else
        Protos::Actor::Role::ROLE_UNKNOWN
    end
    mapped
  end

  sig { void }
  def invalid_authentication
    render json: { error: 'Invalid Request' }, status: :unauthorized
  end
end
