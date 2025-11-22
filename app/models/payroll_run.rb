class PayrollRun < ApplicationRecord
  validates :pay_period_start, :pay_period_end, :status, presence: true
  validates :total_hours, :total_overtime, :gross_pay, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  STATUSES = ['Draft', 'Processing', 'Completed', 'Failed'].freeze

  validates :status, inclusion: { in: STATUSES }

  scope :completed, -> { where(status: 'Completed') }
  scope :for_period, ->(start_date, end_date) { where(pay_period_start: start_date, pay_period_end: end_date) }

  def pay_period_description
    "#{pay_period_start.strftime('%B %d, %Y')} - #{pay_period_end.strftime('%B %d, %Y')}"
  end
end
