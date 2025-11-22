# frozen_string_literal: true

namespace :payroll do
  desc "Generate monthly payroll CSV report"
  task generate: :environment do
    # Get the previous month by default, or use provided date
    date = ENV['DATE']&.to_date || Date.current.prev_month
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    
    puts "Generating payroll report for #{date.strftime('%B %Y')}..."
    
    # Get all employees (this would normally be scoped by user/company)
    employees = Employee.all
    
    if employees.empty?
      puts "No employees found."
      exit
    end
    
    # Generate CSV
    require 'csv'
    
    csv_data = CSV.generate do |csv|
      # Header row
      csv << ['Employee Name', 'Email', 'Hours Worked', 'Overtime Hours', 'Gross Pay', 'Period Start', 'Period End']
      
      employees.each do |employee|
        hours = employee.total_hours_for_period(start_date, end_date)
        overtime = employee.total_overtime_for_period(start_date, end_date)
        
        # Calculate gross pay (assuming 173.33 hours/month for full-time)
        regular_pay = (hours * employee.salary / 173.33)
        overtime_pay = (overtime * employee.salary / 173.33 * 1.5) # Time and a half
        gross_pay = regular_pay + overtime_pay
        
        csv << [
          employee.full_name,
          employee.email,
          hours,
          overtime,
          ActionController::Base.helpers.number_to_currency(gross_pay),
          start_date,
          end_date
        ]
      end
    end
    
    # Save to file or output to console
    if ENV['OUTPUT_FILE']
      File.write(ENV['OUTPUT_FILE'], csv_data)
      puts "Payroll report saved to #{ENV['OUTPUT_FILE']}"
    else
      puts "\nPayroll Report for #{date.strftime('%B %Y')}:"
      puts csv_data
    end
    
    puts "\nReport generated successfully!"
    puts "Total employees: #{employees.count}"
    puts "Period: #{start_date} to #{end_date}"
  end
  
  desc "Generate payroll with custom date range"
  task generate_range: :environment do
    start_date = ENV['START_DATE']&.to_date || Date.current.beginning_of_month
    end_date = ENV['END_DATE']&.to_date || Date.current.end_of_month
    
    puts "Generating payroll report from #{start_date} to #{end_date}..."
    
    employees = Employee.all
    
    if employees.empty?
      puts "No employees found."
      exit
    end
    
    require 'csv'
    
    csv_data = CSV.generate do |csv|
      csv << ['Employee Name', 'Email', 'Hours Worked', 'Overtime Hours', 'Gross Pay', 'Period Start', 'Period End']
      
      employees.each do |employee|
        hours = employee.total_hours_for_period(start_date, end_date)
        overtime = employee.total_overtime_for_period(start_date, end_date)
        
        regular_pay = (hours * employee.salary / 173.33)
        overtime_pay = (overtime * employee.salary / 173.33 * 1.5)
        gross_pay = regular_pay + overtime_pay
        
        csv << [
          employee.full_name,
          employee.email,
          hours,
          overtime,
          ActionController::Base.helpers.number_to_currency(gross_pay),
          start_date,
          end_date
        ]
      end
    end
    
    if ENV['OUTPUT_FILE']
      File.write(ENV['OUTPUT_FILE'], csv_data)
      puts "Payroll report saved to #{ENV['OUTPUT_FILE']}"
    else
      puts csv_data
    end
  end
end