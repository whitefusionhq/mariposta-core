require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require 'rails'
require "action_controller/railtie"
require "action_mailer/railtie"
require 'rails/test_unit/railtie'

#Bundler.require(*Rails.groups)
require "mariposta-core"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
