require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in create(:admin)
    @role = create(:role)
  end

  test "should get index" do
    get roles_url
    assert_response :success
  end

  test "should get new" do
    get new_role_url
    assert_response :success
  end

  test "should create role" do
    assert_difference("Role.count") do
      post roles_url, params: {role: {name: "Project Manager"}}
    end

    assert_redirected_to roles_url
  end

  test "should show role" do
    get role_url(@role)
    assert_response :success
  end

  test "should get edit" do
    get edit_role_url(@role)
    assert_response :success
  end

  test "should update role" do
    patch role_url(@role), params: {role: {name: @role.name}}
    assert_redirected_to role_url(@role)
  end

  test "should destroy role" do
    assert_difference("Role.count", -1) do
      delete role_url(@role)
    end

    assert_redirected_to roles_url
  end
end
