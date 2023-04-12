require "test_helper"

class CagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cage = cages(:one)
  end

  test "should get index" do
    get cages_url, as: :json
    assert_response :success
  end

  test "should create cage" do
    assert_difference('Cage.count') do
      post cages_url, params: { cage: { capacity: @cage.capacity, name: @cage.name, status: @cage.status } }, as: :json
    end

    assert_response 201
  end

  test "should show cage" do
    get cage_url(@cage), as: :json
    assert_response :success
  end

  test "should update cage" do
    patch cage_url(@cage), params: { cage: { capacity: @cage.capacity, name: @cage.name, status: @cage.status } }, as: :json
    assert_response 200
  end

  test "should destroy cage" do
    assert_difference('Cage.count', -1) do
      delete cage_url(@cage), as: :json
    end

    assert_response 204
  end
end
