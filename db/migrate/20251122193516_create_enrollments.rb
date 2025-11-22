class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :benefit_plan, null: false, foreign_key: true
      t.date :enrollment_date
      t.string :status

      t.timestamps
    end
  end
end
