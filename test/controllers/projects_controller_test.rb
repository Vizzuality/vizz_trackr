require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @team = teams(:one)
    @project = projects(:one)
  end

  test 'should get index' do
    get projects_url
    @request.env['devise.mapping'] = Devise.mappings[:user]
    assert_response :success
  end

  test 'should get new' do
    get new_project_url
    @request.env['devise.mapping'] = Devise.mappings[:user]
    assert_response :success
  end

  test 'should create project' do
    assert_difference('Project.count') do
      post projects_url, params: {
        project: {
          name: 'Counting Crows'
        }
      }
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    assert_redirected_to projects_url
  end

  test 'should show project' do
    get project_url(@project)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    assert_response :success
  end

  test 'should get edit' do
    get edit_project_url(@project)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    assert_response :success
  end

  test 'should update project' do
    patch project_url(@project), params: {
      project: {
        name: @project.name
      }
    }
    @request.env['devise.mapping'] = Devise.mappings[:user]
    assert_redirected_to project_url(@project)
  end

  test 'should destroy project' do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    assert_redirected_to projects_url
  end
end
