require 'spec_helper'

describe Psigner::Application do

  describe "GET '/api/sign'" do
    it "should fail" do
      get '/'
      last_response.should_not be_ok
    end
  end

  describe "POST '/api/sign'" do
    it "should fail to get the API signing page without parameters" do
      post '/api/sign'
      last_response.status.should == 400
    end

    it "should fail to get the API signing page with only one parameter" do
      post '/api/sign', params = { "secret" => "SHAREDSECRET" }
      last_response.status.should == 400
    end

    it "should get the API signing page" do
      post '/api/sign', params = { "secret" => "SHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 200
    end

    it "should fail with incorrect shared secret" do
      post '/api/sign', params = { "secret" => "NOSHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 401
    end
  end
end
