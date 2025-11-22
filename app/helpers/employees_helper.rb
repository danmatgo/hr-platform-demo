module EmployeesHelper
  def employee_initials(employee)
    (employee.first_name.first.to_s + employee.last_name.first.to_s).upcase
  end

  def badge(text, color = 'gray')
    base = "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium"
    colors = {
      'blue' => 'bg-blue-50 text-blue-700',
      'green' => 'bg-green-50 text-green-700',
      'gray' => 'bg-gray-100 text-gray-700',
      'purple' => 'bg-purple-50 text-purple-700',
      'orange' => 'bg-orange-50 text-orange-700',
      'red' => 'bg-red-50 text-red-700'
    }
    classes = "#{base} #{colors[color] || colors['gray']}"
    content_tag(:span, text, class: classes)
  end
end
