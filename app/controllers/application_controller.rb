class ApplicationController < ActionController::Base
  if ENV['BASIC_AUTH_ENABLED']
    http_basic_authenticate_with name: ENV.fetch('BASIC_AUTH_USER'), password: ENV.fetch('BASIC_AUTH_PASSWORD')
  end

  protect_from_forgery with: :exception
end
