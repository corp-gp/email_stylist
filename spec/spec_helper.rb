# frozen_string_literal: true

require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
