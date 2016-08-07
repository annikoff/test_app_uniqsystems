require 'capybara/rspec'
require 'database_cleaner'

include Warden::Test::Helpers

Capybara.javascript_driver = :webkit
