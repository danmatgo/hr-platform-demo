class DashboardController < ApplicationController
  def index
    @total_employees = current_user.employees.count
    @total_time_entries = TimeEntry.joins(:employee).where(employees: { user_id: current_user.id }).count
    @total_benefit_plans = BenefitPlan.count
    @recent_payroll_runs = PayrollRun.order(created_at: :desc).limit(5)
  end
end
