require 'spec_helper'

describe Oshpark::Client do
  let(:connection) { FakeClient.new "foo"}
  subject          { Oshpark::Client.new connection: connection }

  describe '#initialize' do
    it 'attempts to retrieve an API token immediately' do
      subject
      expect(connection.requests.last).to eq([:post, 'sessions', {}])
    end
  end

  describe '#authenticate' do
    it 'attempts to authenticate an API token with a password' do
      subject.authenticate 'email', with_password: 'pass'
      expect(connection.requests.last).to eq([:post, 'sessions', {email: 'email', password: 'pass'}])
    end

    it 'attempts to authenticate an API token with an API secret' do
      subject.authenticate 'email', with_api_secret: 'secret'
      expect(connection.requests.last).to eq([:post, 'sessions', {email: 'email', api_key: 'add39dedbfe932ce383881dac4870bf417ebb79e1ec743e5c1e3bec574a2e821'}])
    end
  end

  describe '#projects' do
    it 'retrieves a list of projects from the API' do
      subject.projects
      expect(connection.requests.last).to eq([:get, 'projects', {}])
    end
  end

  describe '#project' do
    let(:token) { 'abcd1234' }
    it 'retrieves a project from the API' do
      subject.project token
      expect(connection.requests.last).to eq([:get, "projects/#{token}", {}])
    end
  end

  describe '#approve_project' do
    let(:token) { 'abcd1234' }
    it 'approve a project via the API' do
      subject.approve_project(token)
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

  describe "#pricing" do
    let(:width)  { 1000 }
    let(:height) { 1000 }
    let(:layers) { 2 }

    it "return pricing information" do
      subject.pricing width, height, layers
      expect(connection.requests.last).to eq([:post, "pricing", {width_in_mils: 1000, height_in_mils: 1000, pcb_layers: 2, quantity: nil}])
    end
  end

  describe '#orders' do
    it 'retrieves a list of orders from the API' do
      subject.orders
      expect(connection.requests.last).to eq([:get, 'orders', {}])
    end
  end

  describe '#order' do
    let(:token) { 'abcd1234' }
    it 'retrieves a order from the API' do
      subject.order token
      expect(connection.requests.last).to eq([:get, "orders/#{token}", {}])
    end
  end

  describe '#create_order' do
    it "creates an order" do
      subject.create_order
      expect(connection.requests.last).to eq([:post, "orders", {}])
    end
  end

  describe '#add_order_item' do
    let(:token)      { 'abcd1234' }
    let(:project_id) { '1234abcd' }
    let(:quantity)   { 6 }
    it "add an order item to an order" do
      subject.add_order_item token, project_id, quantity
      expect(connection.requests.last).to eq([:post, "orders/#{token}/add_item", {order: {:project_id=>"1234abcd", :quantity=>6}}])
    end
  end

  describe '#set_order_address' do
    let(:token)   { 'abcd1234' }
    let(:address) { {"name" => "Bob", "company_name" => nil, "address_line_1" => "8 Nelson Street", "address_line_2" => "Petone", "city" => "Lower Hutt", "state" => nil, "zip_or_postal_code" => nil, "country" => "New Zealand", "phone_number" => nil, "is_business" => nil} }
    it "set the delivery address for an order" do
      subject.set_order_address token, address
      expect(connection.requests.last).to eq([:post, "orders/#{token}/set_address", {order: {address: {"name" => "Bob", "company_name" => nil, "address_line_1" => "8 Nelson Street", "address_line_2" => "Petone", "city" => "Lower Hutt", "state" => nil, "zip_or_postal_code" => nil, "country" => "New Zealand", "phone_number" => nil, "is_business" => nil}}}])
    end
  end

  describe "#shipping_rates" do
    let(:token)   { 'abcd1234' }
    let(:address) { {"name" => "Bob", "company_name" => nil, "address_line_1" => "8 Nelson Street", "address_line_2" => "Petone", "city" => "Lower Hutt", "state" => nil, "zip_or_postal_code" => nil, "country" => "New Zealand", "phone_number" => nil, "is_business" => nil} }
    it "returns shipping rates" do
      subject.shipping_rates address
      expect(connection.requests.last).to eq([:post, "shipping_rates", {:address => {"name" => "Bob", "company_name" => nil, "address_line_1" => "8 Nelson Street", "address_line_2" => "Petone", "city" => "Lower Hutt", "state" => nil, "zip_or_postal_code" => nil, "country" => "New Zealand", "phone_number" => nil, "is_business" => nil}}])
    end
  end

  describe '#set_order_shipping_rate' do
    let(:token)            { 'abcd1234' }
    let(:service_provider) { 'Bobs Mail'}
    let(:service_name)     { 'Overnight Delivery' }
    it "sets the shipping rate for an order" do
      subject.set_order_shipping_rate token, service_provider, service_name
      expect(connection.requests.last).to eq([:post, "orders/#{token}/set_shipping_rate", {order: {shipping_rate: {carrier_name: "Bobs Mail", service_name: "Overnight Delivery"}}}])
    end
  end

  describe '#checkout_order' do
    let(:token) { 'abcd1234' }
    it "checks out an order" do
      subject.checkout_order token
      expect(connection.requests.last).to eq([:post, "orders/#{token}/checkout", {}])
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
      subject.panels
      expect(connection.requests.last).to eq([:get, 'panels', {}])
    end
  end

  describe '#panel' do
    let(:token) { 'abcd1234' }
    it 'retrieves a panel from the API' do
      subject.panel token
      expect(connection.requests.last).to eq([:get, "panels/#{token}", {}])
    end
  end

end
