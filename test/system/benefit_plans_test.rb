require "application_system_test_case"

class BenefitPlansTest < ApplicationSystemTestCase
  setup do
    @benefit_plan = benefit_plans(:one)
  end

  test "visiting the index" do
    visit benefit_plans_url
    assert_selector "h1", text: "Benefits"
  end

  test "should create benefit plan" do
    visit benefit_plans_url
    click_on "New benefit plan"

    fill_in "Cost", with: @benefit_plan.cost
    fill_in "Coverage type", with: @benefit_plan.coverage_type
    fill_in "Description", with: @benefit_plan.description
    fill_in "Name", with: @benefit_plan.name
    click_on "Create Benefit plan"

    assert_text "Benefit plan was successfully created"
    click_on "Back"
  end

  test "should update Benefit plan" do
    visit benefit_plan_url(@benefit_plan)
    click_on "Edit", match: :first

    fill_in "Cost", with: @benefit_plan.cost
    fill_in "Coverage type", with: @benefit_plan.coverage_type
    fill_in "Description", with: @benefit_plan.description
    fill_in "Name", with: @benefit_plan.name
    click_on "Update Benefit plan"

    assert_text "Benefit plan was successfully updated"
    click_on "Back"
  end

  test "should destroy Benefit plan" do
    visit benefit_plan_url(@benefit_plan)
    accept_confirm { click_on "Destroy", match: :first }

    assert_text "Benefit plan was successfully destroyed"
  end
end
