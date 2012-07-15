require "sinatra"
require "yaml"

def load_configuration(file, name)
  if !File.exist?(file)
    puts "There's no configuration file at #{file}!"
    exit!
  end
  Psigner.const_set(name, YAML.load_file(file))
end

module Psigner
  class Application < Sinatra::Base

    configure do
      load_configuration("config/config.yml", "APP_CONFIG")
    end

    set :public_folder, File.join(File.dirname(__FILE__), 'public')
    set :views, File.join(File.dirname(__FILE__), 'views')

    # Sign certificates /api/sign?host=hostname.to.be.signed?secret=sharedsecret
    post '/api/sign' do
      halt 400, "No parameters specified" if params.empty?
      unless params[:secret] && params[:certname]
        halt 400, "You must specify both a shared secret and a certificate name."
      end
      secret, certname = params[:secret], params[:certname]
      if check_secret(secret)
        sign_cert(certname)
      else
       halt 401, "Shared secret does not match - signing unauthorized."
      end
    end

    get '/api/sign' do
      'You need to POST API signing requests'
    end

    helpers do

      def check_secret(secret)
        secret == APP_CONFIG["secret"]
      end

      def sign_cert(certname)
        begin
          signed = `puppet certificate --ca-location local --mode master sign #{certname}`
        rescue => e
          return "Signing failed because: #{e}"
        end
        signed
      end

    end
  end
end
