# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_22_193526) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefit_plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "cost"
    t.string "coverage_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.date "hire_date"
    t.decimal "salary"
    t.string "position"
    t.string "department"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "benefit_plan_id", null: false
    t.date "enrollment_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_plan_id"], name: "index_enrollments_on_benefit_plan_id"
    t.index ["employee_id"], name: "index_enrollments_on_employee_id"
  end

  create_table "payroll_runs", force: :cascade do |t|
    t.date "pay_period_start"
    t.date "pay_period_end"
    t.decimal "total_hours"
    t.decimal "total_overtime"
    t.decimal "gross_pay"
    t.string "status"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_entries", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "work_date"
    t.decimal "hours_worked"
    t.decimal "overtime_hours"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_time_entries_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "employees", "users"
  add_foreign_key "enrollments", "benefit_plans"
  add_foreign_key "enrollments", "employees"
  add_foreign_key "time_entries", "employees"
end
