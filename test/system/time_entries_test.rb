require "application_system_test_case"

class TimeEntriesTest < ApplicationSystemTestCase
  setup do
    @time_entry = time_entries(:one)
  end

  test "visiting the index" do
    visit time_entries_url
    assert_selector "h1", text: "Time Entries"
  end

  test "should create time entry" do
    visit time_entries_url
    click_on "New time entry"

    fill_in "Employee", with: @time_entry.employee_id
    fill_in "Hours worked", with: @time_entry.hours_worked
    fill_in "Notes", with: @time_entry.notes
    fill_in "Overtime hours", with: @time_entry.overtime_hours
    fill_in "Work date", with: @time_entry.work_date
    click_on "Create Time entry"

    assert_text "Time entry was successfully created"
    click_on "Back"
  end

  test "should update Time entry" do
    visit time_entry_url(@time_entry)
    click_on "Edit", match: :first

    fill_in "Employee", with: @time_entry.employee_id
    fill_in "Hours worked", with: @time_entry.hours_worked
    fill_in "Notes", with: @time_entry.notes
    fill_in "Overtime hours", with: @time_entry.overtime_hours
    fill_in "Work date", with: @time_entry.work_date
    click_on "Update Time entry"

    assert_text "Time entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Time entry" do
    visit time_entry_url(@time_entry)
    accept_confirm { click_on "Destroy", match: :first }

    assert_text "Time entry was successfully destroyed"
  end
end
