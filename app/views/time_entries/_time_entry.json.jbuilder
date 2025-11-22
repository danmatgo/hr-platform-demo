json.extract! time_entry, :id, :employee_id, :work_date, :hours_worked, :overtime_hours, :notes, :created_at, :updated_at
json.url time_entry_url(time_entry, format: :json)
