require "test_helper"

class PayrollRunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payroll_run = payroll_runs(:one)
  end

  test "should get index" do
    get payroll_runs_url
    assert_response :success
  end

  test "should get new" do
    get new_payroll_run_url
    assert_response :success
  end

  test "should create payroll_run" do
    assert_difference("PayrollRun.count") do
      post payroll_runs_url, params: { payroll_run: { gross_pay: @payroll_run.gross_pay, pay_period_end: @payroll_run.pay_period_end, pay_period_start: @payroll_run.pay_period_start, processed_at: @payroll_run.processed_at, status: @payroll_run.status, total_hours: @payroll_run.total_hours, total_overtime: @payroll_run.total_overtime } }
    end

    assert_redirected_to payroll_run_url(PayrollRun.last)
  end

  test "should show payroll_run" do
    get payroll_run_url(@payroll_run)
    assert_response :success
  end

  test "should get edit" do
    get edit_payroll_run_url(@payroll_run)
    assert_response :success
  end

  test "should update payroll_run" do
    patch payroll_run_url(@payroll_run), params: { payroll_run: { gross_pay: @payroll_run.gross_pay, pay_period_end: @payroll_run.pay_period_end, pay_period_start: @payroll_run.pay_period_start, processed_at: @payroll_run.processed_at, status: @payroll_run.status, total_hours: @payroll_run.total_hours, total_overtime: @payroll_run.total_overtime } }
    assert_redirected_to payroll_run_url(@payroll_run)
  end

  test "should destroy payroll_run" do
    assert_difference("PayrollRun.count", -1) do
      delete payroll_run_url(@payroll_run)
    end

    assert_redirected_to payroll_runs_url
  end
end
