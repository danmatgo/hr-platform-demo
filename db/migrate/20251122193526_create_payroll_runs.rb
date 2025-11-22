class CreatePayrollRuns < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_runs do |t|
      t.date :pay_period_start
      t.date :pay_period_end
      t.decimal :total_hours
      t.decimal :total_overtime
      t.decimal :gross_pay
      t.string :status
      t.datetime :processed_at

      t.timestamps
    end
  end
end
