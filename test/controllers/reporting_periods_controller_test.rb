require 'test_helper'

class ReportingPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
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
        reporting_period: {date: @reporting_period.date}
      }
    end

    assert_redirected_to reporting_period_url(ReportingPeriod.last)
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
    assert_redirected_to reporting_period_url(@reporting_period)
  end

  test 'should destroy reporting_period' do
    assert_difference('ReportingPeriod.count', -1) do
      delete reporting_period_url(@reporting_period)
    end

    assert_redirected_to reporting_periods_url
  end
end
