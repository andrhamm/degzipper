module Degzipper
  class Rails < Rails::Railtie
    initializer "degzipper.configure_rails_initialization" do |app|
      if ::Rails.version >= "5"
        app.middleware.use Degzipper::Middleware
      else
        app.middleware.insert_before ActionDispatch::ParamsParser, "Degzipper::Middleware"
      end
    end
  end
end
