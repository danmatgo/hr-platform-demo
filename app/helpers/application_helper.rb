module ApplicationHelper
  def greeting_for_time
    hour = Time.current.hour
    return 'Good morning' if hour < 12
    return 'Good afternoon' if hour < 18
    'Good evening'
  end

  def current_user_display_name
    return '' unless user_signed_in?
    email = current_user.email.to_s
    name = email.split('@').first
    name.capitalize
  end

  def pill_switch(options = [])
    content_tag(:div, class: 'inline-flex rounded-full ring-1 ring-gray-300 bg-white overflow-hidden') do
      options.map.with_index do |opt, i|
        classes = 'px-3 py-1 text-sm'
        classes += i.zero? ? ' bg-gray-900 text-white' : ' text-gray-700 hover:bg-gray-100'
        concat(content_tag(:span, opt, class: classes))
      end
    end
  end

  def icon_button_edit(record, classes: '')
    link_to(edit_polymorphic_path(record), class: "icon-btn #{classes}") do
      raw('<svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zm14.71-9.04a1 1 0 000-1.41l-2.5-2.5a1 1 0 00-1.41 0l-1.83 1.83 3.75 3.75 1.99-1.67z"/></svg>')
    end
  end

  def icon_button_delete(record, classes: '')
    button_to(record, method: :delete, class: "icon-btn-danger #{classes}", data: { turbo_confirm: 'Are you sure?' }) do
      raw('<svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor"><path d="M16 9v10H8V9h8m-1.5-6h-5l-1 1H5v2h14V4h-3.5l-1-1z"/></svg>')
    end
  end
end
