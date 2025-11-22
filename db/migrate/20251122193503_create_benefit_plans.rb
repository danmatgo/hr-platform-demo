class CreateBenefitPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :benefit_plans do |t|
      t.string :name
      t.text :description
      t.decimal :cost
      t.string :coverage_type

      t.timestamps
    end
  end
end
