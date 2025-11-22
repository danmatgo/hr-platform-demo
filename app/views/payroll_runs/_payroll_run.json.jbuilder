json.extract! payroll_run, :id, :pay_period_start, :pay_period_end, :total_hours, :total_overtime, :gross_pay, :status, :processed_at, :created_at, :updated_at
json.url payroll_run_url(payroll_run, format: :json)
