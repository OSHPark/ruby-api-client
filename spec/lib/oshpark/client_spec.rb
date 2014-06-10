require 'spec_helper'

describe Oshpark::Client do
  let(:connection) { FakeClient.new }
  subject          { Oshpark::Client.new connection: connection }

  describe '#initialize' do
    it 'attempts to retrieve an API token immediately' do
      subject
      expect(connection.requests.last).to eq([:post, 'sessions', {}])
    end
  end

  describe '#authenticate' do
    it 'attempts to authenticate an API token' do
      subject.authenticate 'user', 'pass'
      expect(connection.requests.last).to eq([:post, 'sessions', {username: 'user', password: 'pass'}])
    end
  end

  describe '#projects' do
    it 'retrieves a list of projects from the API' do
      expect(subject.projects.first).to be_an(Oshpark::Project)
      expect(connection.requests.last).to eq([:get, 'projects', {}])
    end
  end

  describe '#project' do
    let(:token) { 'abcd1234' }
    it 'retrieves a project from the API' do
      expect(subject.project(token)).to be_an(Oshpark::Project)
      expect(connection.requests.last).to eq([:get, "projects/#{token}", {}])
    end
  end

  describe '#approve_project' do
    let(:token) { 'abcd1234' }
    it 'approve a project via the API' do
      expect(subject.approve_project(token)).to be_an(Oshpark::Project)
      expect(connection.requests.last).to eq([:get, "projects/#{token}/approve", {}])
    end
  end

  describe '#destroy_project' do
    let(:token) { 'abcd1234' }
    it 'destroy a project via the API' do
      expect(subject.destroy_project(token)).to eq true
      expect(connection.requests.last).to eq([:delete, "projects/#{token}", {}])
    end
  end

  describe '#orders' do
    it 'retrieves a list of orders from the API' do
      expect(subject.orders.first).to be_an(Oshpark::Order)
      expect(connection.requests.last).to eq([:get, 'orders', {}])
    end
  end

  describe '#order' do
    let(:token) { 'abcd1234' }
    it 'retrieves a order from the API' do
      expect(subject.order(token)).to be_an(Oshpark::Order)
      expect(connection.requests.last).to eq([:get, "orders/#{token}", {}])
    end
  end

  describe '#cancel_order' do
    let(:token) { 'abcd1234' }
    it 'retrieves a order from the API' do
      expect(subject.cancel_order(token)).to eq true
      expect(connection.requests.last).to eq([:delete, "orders/#{token}", {}])
    end
  end

  describe '#panels' do
    it 'retrieves a list of panels from the API' do
      expect(subject.panels.first).to be_an(Oshpark::Panel)
      expect(connection.requests.last).to eq([:get, 'panels', {}])
    end
  end

  describe '#panel' do
    let(:token) { 'abcd1234' }
    it 'retrieves a panel from the API' do
      expect(subject.panel(token)).to be_an(Oshpark::Panel)
      expect(connection.requests.last).to eq([:get, "panels/#{token}", {}])
    end
  end

end
