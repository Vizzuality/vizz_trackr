require "application_system_test_case"

class ReportingPeriodsTest < ApplicationSystemTestCase
  setup do
    @reporting_period = reporting_periods(:one)
  end

  test "visiting the index" do
    visit reporting_periods_url
    assert_selector "h1", text: "Reporting Periods"
  end

  test "creating a Reporting period" do
    visit reporting_periods_url
    click_on "New Reporting Period"

    fill_in "Date", with: @reporting_period.date
    click_on "Create Reporting period"

    assert_text "Reporting period was successfully created"
    click_on "Back"
  end

  test "updating a Reporting period" do
    visit reporting_periods_url
    click_on "Edit", match: :first

    fill_in "Date", with: @reporting_period.date
    click_on "Update Reporting period"

    assert_text "Reporting period was successfully updated"
    click_on "Back"
  end

  test "destroying a Reporting period" do
    visit reporting_periods_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reporting period was successfully destroyed"
  end
end
