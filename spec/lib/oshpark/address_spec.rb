require 'spec_helper'

describe Oshpark::Address do
  context "initialize with a hash" do
    describe ".initialize" do
      let(:args) { {name: "Bob", address_line_1: "8 Nelson Street"} }

      subject { Oshpark::Address.new args }
      it "creats an address" do
        subject.address_line_1.should == "8 Nelson Street"
      end
    end
  end

  context "Initialize with args" do
    describe ".initialize" do
      subject { Oshpark::Address.new name: "Bob", address_line_1: "8 Nelson Street" }
      it "creats an address" do
        subject.address_line_1.should == "8 Nelson Street"
      end
    end
  end
end
