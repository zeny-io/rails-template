# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'
require 'simplecov'
SimpleCov.start('rails') do
  add_filter '/bin/'
  add_filter '/Rakefile'
end if ENV['COV'] != 'skip'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

Dir[Rails.root.join('test', 'support', '**', '*.rb').to_s].each do |f|
  require f
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false
end
