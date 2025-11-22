class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.date :hire_date
      t.decimal :salary
      t.string :position
      t.string :department
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
