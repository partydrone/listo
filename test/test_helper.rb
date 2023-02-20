require "simplecov"
require "simplecov-lcov"
require "simplecov-tailwindcss"
SimpleCov.start "rails" do
  add_filter "/test/"
  coverage_dir "test/coverage"

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::LcovFormatter,
    SimpleCov::Formatter::TailwindFormatter
  ])
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "minitest/rails"
require "minitest/reporters"

Dir[File.expand_path("test/config/**/*.rb")].each { |file| require file }

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true), ENV, Minitest.backtrace_filter

Capybara.server_host = "0.0.0.0"
Capybara.app_host = "http://#{ Socket.gethostname }:#{ Capybara.server_port }"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
