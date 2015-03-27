require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProofOfConcept
  class Application < Rails::Application
    unless ENV['FS_EVENTS'] == "true"
      puts " - USING STANDARD AUTORELOAD -"
      config.autoload_paths += Dir["#{config.root}/lib/rails_autoload"]
    end
  end
end
