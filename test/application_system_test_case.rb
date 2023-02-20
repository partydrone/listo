require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: ENV.fetch("TEST_BROWSER", "chrome").to_sym, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: "http://#{ ENV.fetch("TEST_BROWSER", "chrome") }-server:4444"
  }
end
