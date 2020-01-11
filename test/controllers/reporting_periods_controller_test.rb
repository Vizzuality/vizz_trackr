require 'test_helper'

class ReportingPeriodsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @reporting_period = reporting_periods(:one)
  end

  test 'should get index' do
    get reporting_periods_url
    assert_response :success
  end

  test 'should get new' do
    get new_reporting_period_url
    assert_response :success
  end

  test 'should create reporting_period' do
    assert_difference('ReportingPeriod.count') do
      post reporting_periods_url, params: {
        reporting_period: {date: '2020-01-01'}
      }
    end

    assert_redirected_to reporting_periods_url
  end

  test 'should show reporting_period' do
    get reporting_period_url(@reporting_period)
    assert_response :success
  end

  test 'should get edit' do
    get edit_reporting_period_url(@reporting_period)
    assert_response :success
  end

  test 'should update reporting_period' do
    patch reporting_period_url(@reporting_period), params: {
      reporting_period: {date: @reporting_period.date}
    }
    assert_redirected_to reporting_periods_url
  end

  test 'should destroy reporting_period' do
    assert_difference('ReportingPeriod.count', -1) do
      delete reporting_period_url(@reporting_period)
    end

    assert_redirected_to reporting_periods_url
  end
end
