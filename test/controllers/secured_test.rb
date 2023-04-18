require "test_helper"

class SecuredTest < ActiveSupport::TestCase
  def setup
    @stub_user = Protos::Actor::User.new(identity: '12345', role: Protos::Actor::Role::ROLE_BUILDER)
  end

  def test_valid_token_returns_current_user
    token = JWT.encode({ sub: '12345', Role: 'Builder' }, nil, 'none')

    controller = MockController.new(token: token)

    controller.send(:valid_token?)

    assert_equal @stub_user, controller.instance_variable_get(:@current_user)
  end

  def test_valid_token_raises_error_with_invalid_role
    token = JWT.encode({ sub: '12345', Role: 'Unknown' }, nil, 'none')
    controller = MockController.new(token: token)
    controller.send(:valid_token?)
    has_role = controller.send(:has_role?)
    refute(has_role, 'Expected has_role? to return false')
  end

  def test_valid_token_does_not_raise_error_with_valid_role
    token = JWT.encode({ sub: '12345', Role: 'Builder' }, nil, 'none')
    controller = MockController.new(token: token)
    controller.send(:valid_token?)
    assert_nil(controller.send(:has_role?))
  end

  private

  class MockController < ApplicationController
    requires_roles roles: [Protos::Actor::Role::ROLE_BUILDER]
    attr_accessor :request

    def initialize(token:)
      @request = OpenStruct.new(headers: { 'Authorization' => "Bearer #{token}" })
    end

    def render(*args); end
  end
end
