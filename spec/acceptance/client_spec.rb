require 'spec_helper'

def authenticated_client
  Oshpark::Client.new.tap do |client|
    client.authenticate ENV['USERNAME'], with_password: ENV['PASSWORD']
  end
end

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

  describe '#projects' do
    subject { authenticated_client.projects }

    it { should have_key 'projects' }
    its(['projects']) { should_not be_empty }
  end

  describe '#project' do
    subject { authenticated_client.project ENV['PROJECT'] }

    it { should have_key 'project' }
    its(['project']) { should have_key 'id' }
    it 'has the correct ID' do
      expect(subject['project']['id']).to eq ENV['PROJECT']
    end
  end

end
