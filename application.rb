require 'sinatra/base'
require 'phaxio'

class Application < Sinatra::Application
  # Display faxes within the past 12 hours
  get '/' do
    erb :logs
  end

  get '/logs.json' do
    set_phaxio_creds

    start_time = Time.now - 43_200
    api_response = Phaxio.list_faxes start: start_time
    api_response.body
  end

  get '/send' do
    erb :send
  end

  post '/send' do
    set_phaxio_creds

    api_response = Phaxio.send_fax(
      to: params['to'],
      filename: params['file']['tempfile']
    )
    api_response.body
  end

  private

    def set_phaxio_creds
      Phaxio.config do |config|
        config.api_key = ENV.fetch 'PHAXIO_API_KEY'
        config.api_secret = ENV.fetch 'PHAXIO_API_SECRET'
      end
    end
end
