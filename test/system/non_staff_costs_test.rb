require "application_system_test_case"

class NonStaffCostsTest < ApplicationSystemTestCase
  setup do
    @non_staff_cost = non_staff_costs(:one)
  end

  test "visiting the index" do
    visit non_staff_costs_url
    assert_selector "h1", text: "Non Staff Costs"
  end

  test "creating a Non staff cost" do
    visit non_staff_costs_url
    click_on "New Non Staff Cost"

    fill_in "Contract", with: @non_staff_cost.contract_id
    fill_in "Cost", with: @non_staff_cost.cost
    fill_in "Cost type", with: @non_staff_cost.cost_type
    click_on "Create Non staff cost"

    assert_text "Non staff cost was successfully created"
    click_on "Back"
  end

  test "updating a Non staff cost" do
    visit non_staff_costs_url
    click_on "Edit", match: :first

    fill_in "Contract", with: @non_staff_cost.contract_id
    fill_in "Cost", with: @non_staff_cost.cost
    fill_in "Cost type", with: @non_staff_cost.cost_type
    click_on "Update Non staff cost"

    assert_text "Non staff cost was successfully updated"
    click_on "Back"
  end

  test "destroying a Non staff cost" do
    visit non_staff_costs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Non staff cost was successfully destroyed"
  end
end
