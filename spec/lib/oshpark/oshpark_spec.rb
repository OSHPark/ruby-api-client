require 'spec_helper'

describe Oshpark::Oshpark do
  let(:client) { FakeClient.new }
  subject      { Oshpark::Oshpark.new client: client }

  describe '#initialize' do
    it 'attempts to retrieve an API token immediately' do
      subject
      expect(client.requests.last).to eq([:post, 'sessions', {}])
    end
  end

  describe '#authenticate' do
    it 'attempts to authenticate an API token' do
      subject.authenticate 'user', 'pass'
      expect(client.requests.last).to eq([:post, 'sessions', {username: 'user', password: 'pass'}])
    end
  end

  describe '#projects' do
    it 'retrieves a list of projects from the API' do
      expect(subject.projects.first).to be_an(Oshpark::Project)
      expect(client.requests.last).to eq([:get, 'projects', {}])
    end
  end

  describe '#project' do
    let(:token) { 'abcd1234' }
    it 'retrieves a project from the API' do
      expect(subject.project(token)).to be_an(Oshpark::Project)
      expect(client.requests.last).to eq([:get, "projects/#{token}", {}])
    end
  end

  describe '#orders' do
    it 'retrieves a list of orders from the API' do
      expect(subject.orders.first).to be_an(Oshpark::Order)
      expect(client.requests.last).to eq([:get, 'orders', {}])
    end
  end

  describe '#order' do
    let(:token) { 'abcd1234' }
    it 'retrieves a order from the API' do
      expect(subject.order(token)).to be_an(Oshpark::Order)
      expect(client.requests.last).to eq([:get, "orders/#{token}", {}])
    end
  end

  describe '#panels' do
    it 'retrieves a list of panels from the API' do
      expect(subject.panels.first).to be_an(Oshpark::Panel)
      expect(client.requests.last).to eq([:get, 'panels', {}])
    end
  end

  describe '#panel' do
    let(:token) { 'abcd1234' }
    it 'retrieves a panel from the API' do
      expect(subject.panel(token)).to be_an(Oshpark::Panel)
      expect(client.requests.last).to eq([:get, "panels/#{token}", {}])
    end
  end

end
