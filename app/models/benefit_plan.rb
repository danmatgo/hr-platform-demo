class BenefitPlan < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :employees, through: :enrollments

  validates :name, :description, :cost, :coverage_type, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }

  COVERAGE_TYPES = ['Health', 'Dental', 'Vision', 'Life', 'Disability', 'Retirement'].freeze

  validates :coverage_type, inclusion: { in: COVERAGE_TYPES }
end
