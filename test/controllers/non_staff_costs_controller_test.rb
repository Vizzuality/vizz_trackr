require 'test_helper'

class NonStaffCostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in create(:admin)
    @non_staff_cost = create(:non_staff_cost)
  end

  test 'should get index' do
    get non_staff_costs_url
    assert_response :success
  end

  test 'should get new' do
    get new_non_staff_cost_url
    assert_response :success
  end

  test 'should create non_staff_cost' do
    assert_difference('NonStaffCost.count') do
      post non_staff_costs_url, params: {
        non_staff_cost: {
          contract_id: @non_staff_cost.contract_id,
          cost: @non_staff_cost.cost,
          cost_type: @non_staff_cost.cost_type,
          reporting_period_id: create(:reporting_period).id
        }
      }
    end

    assert_redirected_to non_staff_costs_url
  end

  test 'should show non_staff_cost' do
    get non_staff_cost_url(@non_staff_cost)
    assert_response :success
  end

  test 'should get edit' do
    get edit_non_staff_cost_url(@non_staff_cost)
    assert_response :success
  end

  test 'should update non_staff_cost' do
    patch non_staff_cost_url(@non_staff_cost), params: {
      non_staff_cost: {
        contract_id: @non_staff_cost.contract_id,
        cost: @non_staff_cost.cost,
        cost_type: @non_staff_cost.cost_type
      }
    }
    assert_redirected_to non_staff_cost_url(@non_staff_cost)
  end

  test 'should destroy non_staff_cost' do
    assert_difference('NonStaffCost.count', -1) do
      delete non_staff_cost_url(@non_staff_cost)
    end

    assert_redirected_to non_staff_costs_url
  end
end
