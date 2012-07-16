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
      authenticated_only!

      requires_param :certname

      sign_cert(params[:certname])
    end

    get '/api/sign' do
      'You need to POST API signing requests'
    end

    delete '/api/cert' do
      authenticated_only!
      requires_param :certname

      success, output = clean_cert(params[:certname])
      unless success
        halt 500, {'Content-Type' => 'text/plain'}, output
      end
      "OK"
    end

    helpers do
      def authenticated_only!
        unless params[:secret] == APP_CONFIG['secret']
          halt 401, 'Unauthorised.  Shared secret does not match.'
        end
      end

      def requires_params(*needed)
        halt 400, 'No parameters specified' if params.empty?

        needed.each do |param|
          unless params[param]
            halt 400, "You must specify #{param.to_s} as a parameter"
          end
        end
      end
      alias :requires_param :requires_params

      def sign_cert(certname)
        begin
          signed = `puppet certificate --ca-location local --mode master sign #{certname}`
        rescue => e
          return "Signing failed because: #{e}"
        end
        signed
      end

      def clean_cert(certname)
        stdout = `puppet cert clean #{certname}`
        [$?.exitstatus == 0, stdout]
      end
    end
  end
end
