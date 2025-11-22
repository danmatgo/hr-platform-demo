class PayrollRunsController < ApplicationController
  before_action :set_payroll_run, only: %i[ show edit update destroy ]

  # GET /payroll_runs or /payroll_runs.json
  def index
    @payroll_runs = PayrollRun.order(created_at: :desc)
  end

  # GET /payroll_runs/1 or /payroll_runs/1.json
  def show
  end

  # GET /payroll_runs/new
  def new
    @payroll_run = PayrollRun.new
  end

  # GET /payroll_runs/1/edit
  def edit
  end

  # POST /payroll_runs or /payroll_runs.json
  def create
    @payroll_run = PayrollRun.new(payroll_run_params)

    respond_to do |format|
      if @payroll_run.save
        format.html { redirect_to @payroll_run, notice: "Payroll run was successfully created." }
        format.json { render :show, status: :created, location: @payroll_run }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payroll_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payroll_runs/1 or /payroll_runs/1.json
  def update
    respond_to do |format|
      if @payroll_run.update(payroll_run_params)
        format.html { redirect_to @payroll_run, notice: "Payroll run was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @payroll_run }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payroll_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_runs/1 or /payroll_runs/1.json
  def destroy
    @payroll_run.destroy!

    respond_to do |format|
      format.html { redirect_to payroll_runs_path, notice: "Payroll run was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /payroll/generate
  def generate
    start_date = params[:start_date]&.to_date || Date.current.beginning_of_month
    end_date = params[:end_date]&.to_date || Date.current.end_of_month
    
    # Calculate totals for all employees
    employees = current_user.employees
    total_hours = 0
    total_overtime = 0
    gross_pay = 0
    
    employees.each do |employee|
      hours = employee.total_hours_for_period(start_date, end_date)
      overtime = employee.total_overtime_for_period(start_date, end_date)
      total_hours += hours
      total_overtime += overtime
      gross_pay += (hours * employee.salary / 173.33) + (overtime * employee.salary / 173.33 * 1.5)
    end
    
    @payroll_run = PayrollRun.new(
      pay_period_start: start_date,
      pay_period_end: end_date,
      total_hours: total_hours,
      total_overtime: total_overtime,
      gross_pay: gross_pay,
      status: 'Completed',
      processed_at: Time.current
    )
    
    if @payroll_run.save
      # Generate CSV and send it
      csv_data = generate_payroll_csv(start_date, end_date)
      send_data csv_data, filename: "payroll_#{start_date.strftime('%Y%m')}.csv", type: 'text/csv'
    else
      redirect_to payroll_runs_path, alert: "Failed to generate payroll."
    end
  end
  
  private
  
  def generate_payroll_csv(start_date, end_date)
    require 'csv'
    
    CSV.generate do |csv|
      csv << ['Employee Name', 'Hours Worked', 'Overtime Hours', 'Gross Pay', 'Period Start', 'Period End']
      
      current_user.employees.each do |employee|
        hours = employee.total_hours_for_period(start_date, end_date)
        overtime = employee.total_overtime_for_period(start_date, end_date)
        pay = (hours * employee.salary / 173.33) + (overtime * employee.salary / 173.33 * 1.5)
        
        csv << [
          employee.full_name,
          hours,
          overtime,
          number_to_currency(pay),
          start_date,
          end_date
        ]
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_payroll_run
      @payroll_run = PayrollRun.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payroll_run_params
      params.require(:payroll_run).permit(:pay_period_start, :pay_period_end, :total_hours, :total_overtime, :gross_pay, :status, :processed_at)
    end
end
