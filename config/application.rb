require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoList
  class Application < Rails::Application

    config.active_job.queue_adapter = :sidekiq

    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    
    config.i18n.default_locale = :'pt-BR'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.active_storage.service = :test

  end
end
