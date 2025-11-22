class Employee < ApplicationRecord
  belongs_to :user

  has_many :time_entries, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :benefit_plans, through: :enrollments

  validates :first_name, :last_name, :email, :hire_date, :salary, :position, :department, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary, numericality: { greater_than: 0 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def total_hours_for_period(start_date, end_date)
    time_entries.where(work_date: start_date..end_date).sum(:hours_worked)
  end

  def total_overtime_for_period(start_date, end_date)
    time_entries.where(work_date: start_date..end_date).sum(:overtime_hours)
  end
end
