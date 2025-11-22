class Enrollment < ApplicationRecord
  belongs_to :employee
  belongs_to :benefit_plan

  validates :enrollment_date, :status, presence: true
  validates :employee_id, uniqueness: { scope: :benefit_plan_id, message: "is already enrolled in this benefit plan" }

  STATUSES = ['Active', 'Inactive', 'Pending', 'Cancelled'].freeze

  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where(status: 'Active') }
  scope :by_employee, ->(employee_id) { where(employee_id: employee_id) }
end
