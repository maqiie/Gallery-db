require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GalleryDb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    config.api_only = true

    # Session configuration
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.middleware.use ActionDispatch::Flash

    # CORS configuration
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins 'http://localhost:3000', 
    #     'https://gallery-17bt.vercel.app', 
    #     'https://ujenzi-gallegry-75de7aa1ebe9.herokuapp.com', 
        
    #     resource '*',
    #       headers: :any,
    #       expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
    #       methods: [:get, :post, :options, :delete, :put, :patch]
    #   end
    # end
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3000', 
                'https://gallery-17bt.vercel.app',
                'gallery-17bt.vercel.app',
                'https://ujenzi-gallegry-75de7aa1ebe9.herokuapp.com' 
    
        resource '*',
          headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put, :patch]
      end
    end
    
  end
end
