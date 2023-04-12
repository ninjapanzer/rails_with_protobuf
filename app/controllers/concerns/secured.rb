require 'jwt'
require 'net/http'
require_relative '../../protos/actor_pb.rb'

module Secured
  extend ActiveSupport::Concern

  module RoleMethods
    def requires_roles(roles:)
      @required_roles = roles.map {|role| Protos::Role.lookup(role)}
    end

    def required_roles
      @required_roles || []
    end
  end

  def self.included(base)
    # Define the options for JWT verification
    base.before_action :valid_token?
    base.before_action :has_role?
    base.extend(RoleMethods)
  end

  def valid_token?
    options = {
      algorithm: 'RS256',
      verify_iss: true,
      iss: 'https://yourdomain.auth0.com/',
      verify_aud: true,
      aud: 'your-audience'
    }

    decoded = verify_jwt(token: extract_token_from_header, options: options).first
    @current_user = Protos::User.new(identity: decoded["sub"], role: role_mapper(role: decoded["Role"]))
  end

  def has_role?
    if self.class.required_roles.length > 0
      if !self.class.required_roles.include?(@current_user.role)
        invalid_authentication
      end
    else
      invalid_authentication
    end
  end

  private

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
    decoded_token = JWT.decode(token, nil, false)

    decoded_token
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    if auth_header.nil?
      token = JWT.encode({ sub: '12345', Role: 'scientist' }, nil, 'none')
     # invalid_authentication
    else
      token = auth_header.split(' ').last
      token
    end
  end

  def role_mapper(role:)
    mapped = case role.downcase
      when 'builder'
        Protos::Role::ROLE_BUILDER
      when 'scientist'
        Protos::Role::ROLE_SCIENTIST
      else
        Protos::Role::ROLE_UNKNOWN
    end
    mapped
  end

  def invalid_authentication
    render json: { error: 'Invalid Request' }, status: :unauthorized
  end
end
