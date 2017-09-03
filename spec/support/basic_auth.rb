RSpec.shared_context 'basic auth', type: :controller do
  def set_basic_auth username, password
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    request.env['HTTP_AUTHORIZATION'] = credentials
  end
end

RSpec.configure do |config|
  config.include_context 'basic auth', type: :controller

  config.before(:each, type: :controller) do
    set_basic_auth BASIC_AUTH_USER, BASIC_AUTH_PASSWORD
  end
end
