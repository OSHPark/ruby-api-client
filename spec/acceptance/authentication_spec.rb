require 'spec_helper'

describe Oshpark::Client do
  extend SwitchCassette

  its(:token) { should be_valid }

  describe '#authenicate' do
    subject do
      Oshpark::Client.new.tap do |client|
        client.authenticate ENV['USERNAME'], credentials
      end
    end

    describe 'with a password' do
      let(:credentials) { { with_password: password } }

      describe 'with a valid password' do
        let(:password) { ENV['PASSWORD'] }

        its(:token) { should be_valid }
      end

      describe 'with an invalid password' do
        let(:password) { MicroToken.generate 20 }

        it 'raises an not authorized error' do
          expect { subject }.to raise_error Oshpark::Unauthorized
        end
      end
    end

    describe 'with an API secret' do
      let(:credentials) { { with_api_secret: api_secret } }

      describe 'with a valid API secret' do
        let(:api_secret) { ENV['API_SECRET'] }

        its(:token) { should be_valid }
      end

      describe 'with an invalid API secret' do
        let(:api_secret) { MicroToken.generate }

        it 'raises an not authorized error' do
          expect { subject }.to raise_error Oshpark::Unauthorized
        end
      end
    end
  end
end
