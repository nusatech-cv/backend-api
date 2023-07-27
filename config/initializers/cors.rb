Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'  # Set the appropriate origin(s) or '*' to allow all origins
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :head]
    end
  end
  