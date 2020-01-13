require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in create(:admin)
    @team = create(:team)
  end

  test 'should get index' do
    get teams_url
    assert_response :success
  end

  test 'should get new' do
    get new_team_url
    assert_response :success
  end

  test 'should create team' do
    assert_difference('Team.count') do
      post teams_url, params: {team: {name: 'Team Super'}}
    end

    assert_redirected_to teams_url
  end

  test 'should show team' do
    get team_url(@team)
    assert_response :success
  end

  test 'should get edit' do
    get edit_team_url(@team)
    assert_response :success
  end

  test 'should update team' do
    patch team_url(@team), params: {team: {name: @team.name}}
    assert_redirected_to team_url(@team)
  end

  test 'should destroy team' do
    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to teams_url
  end
end
