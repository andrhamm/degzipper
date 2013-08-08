module Degzipper
  class Rails < Rails::Railtie
    initializer "degzipper.configure_rails_initialization" do |app|
      app.middleware.insert_before ActionDispatch::ParamsParser, "Degzipper::Middleware"
    end
  end
end