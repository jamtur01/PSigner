require 'spec_helper'

describe PSigner::Application do

  describe "GET '/api/cert'" do
    it "should fail" do
      get '/'
      last_response.should_not be_ok
    end
  end

  describe "POST '/api/cert'" do
    it "should fail to sign the cert without parameters" do
      post '/api/cert'
      last_response.status.should == 401
    end

    it "should fail to sign via the API with only one parameter" do
      post '/api/cert', params = { "secret" => "SHAREDSECRET" }
      last_response.status.should == 400
    end

    it "should fail with incorrect shared secret" do
      post '/api/cert', params = { "secret" => "NOSHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 401 
    end

    it "should sign via the API with correct parameters" do
      post '/api/cert', params = { "secret" => "SHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 200
    end

  end

  describe "DELETE '/api/cert'" do
    it "should fail to delete the cert without parameters" do
      delete '/api/cert'
      last_response.status.should == 401
    end

    it "should fail to delete the cert with only one parameter" do
      delete '/api/cert', params = { "secret" => "SHAREDSECRET" }
      last_response.status.should == 400
    end

    it "should fail with incorrect shared secret" do
      delete '/api/cert', params = { "secret" => "NOSHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 401
    end

    it "should delete via the API with correct parameters" do
      delete '/api/cert', params = { "secret" => "SHAREDSECRET", "certname" => "bob" }
      last_response.status.should == 200
    end


  end
end
