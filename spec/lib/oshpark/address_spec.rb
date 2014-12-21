require 'spec_helper'

describe Oshpark::Address do
  describe ".initialize" do
    let(:args) { {"address" => {name: "Bob", address_line_1: "8 Nelson Street", address_line_2: "Petone",  city: "Lower Hutt", country: "New Zealand"}} }

    subject { Oshpark::Address.new args }
    it "creates an address" do
      expect(subject.address_line_1).to eq "8 Nelson Street"
    end
  end

end
