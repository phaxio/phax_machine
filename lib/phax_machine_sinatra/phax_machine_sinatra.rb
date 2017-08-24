require 'sinatra/base'
require 'phaxio'
require 'mail'
require 'pony'
require 'json'
require 'tempfile'
require 'sequel'

if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

if not ENV['PHAXIO_API_KEY'] or not ENV['PHAXIO_API_SECRET']
  raise "You must specify your phaxio API keys in PHAXIO_API_KEY and PHAXIO_API_SECRET"
end

class PhaxMachineSinatra < Sinatra::Application
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

  get '/mailphax' do
    erb :mailphax
  end

  get '/mandrill' do
    [501, "mandrill not implemented yet"]
  end

  post '/mandrill' do
    [501, "mandrill not implemented yet"]
  end

  get '/mailgun' do
    [400, "Mailgun supported, but callbacks must be POSTs"]
  end

  post '/mailgun' do
    if not params['sender']
      return [400, "Must include a sender"]
    elsif not params['recipient']
      return [400, "Must include a recipient"]
    end

    files = []
    attachmentCount = params['attachment-count'].to_i

    i = 1
    while i <= attachmentCount do
      #add the file to the hash
      outputFile = "/tmp/#{Time.now.to_i}-#{rand(200)}-" + params["attachment-#{i}"][:filename]

      file_data = File.binread(params["attachment-#{i}"][:tempfile].path)
      IO.binwrite(outputFile, file_data)

      files.push(outputFile)

      i += 1
    end

    sendFax(params['sender'], params['recipient'],files)
    "OK"
  end

  get '/sendgrid' do
    [501, "sendgrid not implemented yet"]
  end

  post '/fax_received' do
    @fax = JSON.parse params['fax']

    recipient_number = Phonelib.parse(@fax['to_number']).e164
    email_address = db[:users].where(fax_number: recipient_number).first[:email]

    fax_from = @fax['from_number']
    fax_file_name = params['filename']['filename']
    fax_file_contents = params['filename']['tempfile'].read
    email_subject = "Fax received from #{fax_from}"

    Pony.mail(
      to: email_address,
      from: smtp_from_address,
      subject: email_subject,
      html_body: erb(:fax_email, layout: false),
      attachments: {
        fax_file_name => fax_file_contents
      },
      via: :smtp,
      via_options: smtp_options
    )
  end

  get '/download_file' do
    set_phaxio_creds

    fax_id = params["fax_id"].to_i
    api_response = Phaxio.get_fax_file(id: fax_id, type: "p")
    tempfile = Tempfile.new(['fax', '.pdf'])
    IO.binwrite tempfile.path, api_response.body
    logger.warn "Sending file with length #{File.size(tempfile.path)}"
    send_file tempfile.path, disposition: :attachment
  end

  private

    def set_phaxio_creds
      Phaxio.config do |config|
        config.api_key = ENV.fetch 'PHAXIO_API_KEY'
        config.api_secret = ENV.fetch 'PHAXIO_API_SECRET'
      end
    end

    def sendFax(fromEmail, toEmail, filenames)
      set_phaxio_creds

      from_fax_number = db[:users].where(email: fromEmail).first[:fax_number]

      number = Mail::Address.new(toEmail).local

      options = {to: number, caller_id: from_fax_number, :"tag[user]" => fromEmail}

      filenames.each_index do |idx|
        options["filename[#{idx}]"] = File.new(filenames[idx])
      end

      logger.info "#{fromEmail} is attempting to send #{filenames.length} files to #{number}..."
      result = Phaxio.send_fax(options)
      result = JSON.parse result.body

      if result['success']
        logger.info "Fax queued up successfully: ID #" + result['data']['faxId'].to_s
      else
        logger.warn "Problem submitting fax: " + result['message']

        if ENV['SMTP_HOST']
          #send mail back to the user telling them there was a problem

          Pony.mail(
            :to => fromEmail,
            :from => smtp_from_address,
            :subject => 'Mailfax: There was a problem sending your fax',
            :body => "There was a problem faxing your #{filenames.length} files to #{number}: " + result['message'],
            :via => :smtp,
            :via_options => smtp_options
          )
        end
      end
    end

    def smtp_options
      {
        :address                => ENV['SMTP_HOST'],
        :port                   => (ENV['SMTP_PORT'] || 25),
        :enable_starttls_auto   => ENV['SMTP_TLS'],
        :user_name              => ENV['SMTP_USER'],
        :password               => ENV['SMTP_PASSWORD'],
        :authentication         => :login
      }
    end

    def smtp_from_address
      ENV['SMTP_FROM'] || 'phaxmachine@phaxio.com'
    end

    def db
      @db ||= Sequel.connect(ENV["DATABASE_URL"])
    end
end
