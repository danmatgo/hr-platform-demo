class CreateTimeEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :time_entries do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :work_date
      t.decimal :hours_worked
      t.decimal :overtime_hours
      t.text :notes

      t.timestamps
    end
  end
end
