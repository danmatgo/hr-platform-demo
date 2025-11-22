class TimeEntry < ApplicationRecord
  belongs_to :employee

  validates :work_date, :hours_worked, presence: true
  validates :hours_worked, numericality: { greater_than_or_equal_to: 0 }
  validates :overtime_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :for_period, ->(start_date, end_date) { where(work_date: start_date..end_date) }
  scope :regular_hours, -> { where(overtime_hours: 0).or(where(overtime_hours: nil)) }
  scope :overtime, -> { where('overtime_hours > 0') }
end
