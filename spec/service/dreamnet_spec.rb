# encoding: utf-8
require 'spec_helper'

describe "Dreamnet" do

  describe "Dreamnet#to" do
    let(:username) { 'api' }
    let(:password) { 'password' }
    let(:url) { "http://tempuri.org/MWGate/wmgw.asmx/MongateCsSpSendSmsNew" }
    let(:content) { '123456' }
    subject { ChinaSMS::Service::Dreamnet.to phone, content, username: username, password: password }

    describe 'single phone' do
      let(:phone) { '13928935535' }

      before do
        stub_request(:post, url).
          with(
            :body => {
              "userId" => username,
              "password" => password,
              "pszMobis" => phone,
              "pszMsg" => content,
              "iMobiCount" => 1,
              "pszSubPort" => '*'
            }, 
            :headers => {
              'Accept'=>'*/*', 
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
              'Host'=>'tempuri.org',
              'Content-Type'=>'application/x-www-form-urlencoded', 
              'User-Agent'=>'Ruby'
            }
          ).
          to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"utf-8\"?><string xmlns=\"http://tempuri.org/\">4589064392983060880</string>', headers: {})

          stub_request(:post, url).
          with(
            :body => 'userId=api&password=password&pszMobis=13928935535&pszMsg=123456&iMobiCount=1&pszSubPort=*', 
            :headers => {
              'Accept'=>'*/*', 
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
              'Host'=>'tempuri.org',
              'Content-Type'=>'application/x-www-form-urlencoded', 
              'User-Agent'=>'Ruby'
            }
          ).
          to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"utf-8\"?><string xmlns=\"http://tempuri.org/\">4589064392983060880</string>', headers: {})
      end

      its([:success]) { should eql true }
      its([:code]) { should eql '4589064392983060880' }
    end
  end

end
