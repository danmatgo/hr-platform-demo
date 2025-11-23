require "application_system_test_case"

class PayrollRunsTest < ApplicationSystemTestCase
  setup do
    @payroll_run = payroll_runs(:one)
  end

  test "visiting the index" do
    visit payroll_runs_url
    assert_selector "h1", text: "Payroll"
  end

  test "should create payroll run" do
    visit payroll_runs_url
    click_on "New payroll run"

    fill_in "Gross pay", with: @payroll_run.gross_pay
    fill_in "Pay period end", with: @payroll_run.pay_period_end
    fill_in "Pay period start", with: @payroll_run.pay_period_start
    fill_in "Processed at", with: @payroll_run.processed_at
    fill_in "Status", with: @payroll_run.status
    fill_in "Total hours", with: @payroll_run.total_hours
    fill_in "Total overtime", with: @payroll_run.total_overtime
    click_on "Create Payroll run"

    assert_text "Payroll run was successfully created"
    click_on "Back"
  end

  test "should update Payroll run" do
    visit payroll_run_url(@payroll_run)
    click_on "Edit", match: :first

    fill_in "Gross pay", with: @payroll_run.gross_pay
    fill_in "Pay period end", with: @payroll_run.pay_period_end
    fill_in "Pay period start", with: @payroll_run.pay_period_start
    fill_in "Processed at", with: @payroll_run.processed_at
    fill_in "Status", with: @payroll_run.status
    fill_in "Total hours", with: @payroll_run.total_hours
    fill_in "Total overtime", with: @payroll_run.total_overtime
    click_on "Update Payroll run"

    assert_text "Payroll run was successfully updated"
    click_on "Back"
  end

  test "should destroy Payroll run" do
    visit payroll_run_url(@payroll_run)
    accept_confirm { click_on "Destroy", match: :first }

    assert_text "Payroll run was successfully destroyed"
  end
end
