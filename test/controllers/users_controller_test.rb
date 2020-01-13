require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in create(:admin)
    @user = create(:user)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          name: 'New User',
          email: 'new-user@example.com',
          role_id: @user.role_id,
          team_id: @user.team_id
        }
      }
    end

    assert_redirected_to users_url
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: {
      user: {
        name: @user.name,
        role_id: @user.role_id,
        team_id: @user.team_id
      }
    }
    assert_redirected_to users_url
  end

  test 'should destroy user' do
    delete user_url(@user)

    assert @user.active, false
    assert_redirected_to users_url
  end
end
