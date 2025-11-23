if Rails.env.test? || Rails.env.development?
  User.find_or_create_by!(email: "admin@example.com") do |u|
    u.password = "password123"
    u.password_confirmation = "password123"
  end
end
