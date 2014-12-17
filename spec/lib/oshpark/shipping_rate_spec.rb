require 'spec_helper'

describe Oshpark::ShippingRate do
  before do
    Oshpark::client url: 'blarg',  connection: FakeClient.new("foo")
  end

  subject { Oshpark::ShippingRate.new({}) }
  it { should be_an Oshpark::Model }

  describe 'rates_for_address' do
    let(:address_params) { {name: "Bob", address_line_1: "8 Nelson Street", address_line_2: "Petone",  city: "Lower Hutt", country: "New Zealand"} }
    let(:address) { Oshpark::Address.new address_params }
    subject { Oshpark::ShippingRate.rates_for_address address }

    before do
      expect(Oshpark::client).to receive(:shipping_rates).
        with({"name" => "Bob", "company_name" => nil, "address_line_1" => "8 Nelson Street", "address_line_2" => "Petone", "city" => "Lower Hutt", "state" => nil, "zip_or_postal_code" => nil, "country" => "New Zealand", "phone_number" => nil, "is_business" => nil}).
        and_return({'shipping_rates' => [:carrier_name => "Pete's Post", :service_name => "Pony Express", :price => "$25.95"]})
    end

    it "returns a list of shipping rates for the Order" do
      expect(subject).to be_an Array
    end

    it "returns ShippingRate objects" do
      expect(subject.first).to be_an Oshpark::ShippingRate
    end
  end

end



