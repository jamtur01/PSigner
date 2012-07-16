$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'psigner'
require 'rspec'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_framework = :mocha
end

ENV['RACK_ENV'] = "test"

def app
  @app ||= PSigner::Application
end

# quick convenience methods..

def fixtures_path
  "#{File.dirname(File.expand_path(__FILE__))}/fixtures"
end
