require "test_helper"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("headless")
  options.add_argument("disable-gpu")
  options.add_argument("no-sandbox")
  options.add_argument("disable-dev-shm-usage")

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :chrome,
    options: options
  }
end
