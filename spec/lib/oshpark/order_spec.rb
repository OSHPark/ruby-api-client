require 'spec_helper'

describe Oshpark::Order do
  before do
    Oshpark::client url: 'blarg',  connection: FakeClient.new("foo")
  end

  subject { Oshpark::Order.new({}) }
  it { should be_an Oshpark::Model }
  it { should be_an Oshpark::RemoteModel }

  %w| id board_cost cancellation_reason cancelled_at ordered_at payment_provider payment_received_at project_name quantity shipping_address shipping_cost shipping_country shipping_method shipping_name state total_cost project_id panel_id |.each do |attr|
    it { should respond_to attr }
  end

  describe '#panel' do
    it 'retrieves a panel' do
      allow(subject).to receive(:panel_id).and_return('abcd1234')
      expect(Oshpark::Panel).to receive(:find).with('abcd1234')
      subject.panel
    end
  end

  describe '#project' do
    it 'retrieves a project' do
      allow(subject).to receive(:project_id).and_return('abcd1234')
      expect(Oshpark::Project).to receive(:find).with('abcd1234')
      subject.project
    end
  end

  describe '.create' do
    before { expect(Oshpark::client).to receive(:create_order).and_return({'order' => {id: "abcd1234", state: 'New'}}) }
    subject { Oshpark::Order.create }

    it 'creates a new Order' do
      expect(subject).to be_an Oshpark::Model
    end

    it 'sets the Order fields correctly' do
      expect(subject.id).to    eq 'abcd1234'
      expect(subject.state).to eq 'New'
    end
  end

  describe '#add_item' do
    let(:item)     { Oshpark::Project.new({id: '1234abcd'}) }
    let(:quantity) { 6 }
    it 'adds Project to an Order' do
      allow(subject).to receive(:id).and_return('abcd1234')

      expect(item).to receive(:id).and_return('1234abcd')
      expect(Oshpark::client).to receive(:add_order_item).with("abcd1234", "1234abcd", 6).and_return({'order' => {id: "abcd1234"}})
      subject.add_item item, quantity
    end
  end

  describe '#set_address' do
    let(:address) { Oshpark::Address.new name: "Bob", address_line_1: "8 Nelson Street", address_line_2: "Petone",  city: "Lower Hutt", country: "New Zealand" }
    it 'sets the delivery Address for an Order' do
      allow(subject).to receive(:id).and_return('abcd1234')

      expect(Oshpark::client).to receive(:set_order_address).with("abcd1234", address).and_return({'order' => {id: "abcd1234"}})
      subject.set_address address
    end
  end

  describe '#set_shipping_rate' do
    let(:shipping_rate) { Oshpark::ShippingRate.new carrier_name: 'Bobs Mail', service_name: 'Overnight Delivery' }
    it 'sets the shipping rate for an Order' do
      allow(subject).to receive(:id).and_return('abcd1234')

      expect(Oshpark::client).to receive(:set_order_shipping_rate).with("abcd1234", shipping_rate).and_return({'order' => {id: "abcd1234"}})
      subject.set_shipping_rate shipping_rate
    end
  end

  describe '#checkout' do
    it 'checks out the order' do
      allow(subject).to receive(:id).and_return('abcd1234')

      expect(Oshpark::client).to receive(:checkout_order).and_return({'order' => {id: "abcd1234"}})
      subject.checkout
    end
  end

end
