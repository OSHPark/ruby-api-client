require 'spec_helper'

describe Oshpark::Price do
  before do
    Oshpark::client url: 'blarg',  connection: FakeClient.new("foo")
  end

  subject { Oshpark::Price.new({}) }
  it { should be_an Oshpark::Model }

  describe 'price_for' do
    let(:width)  { 1000 }
    let(:height) { 1000 }
    let(:layers) { 2 }
    subject { Oshpark::Price.price_for width, height, layers }

    before do
      expect(Oshpark::client).to receive(:pricing).
        with(1000, 1000, 2, nil).
        and_return({'pricing' => {batch_cost: "5.00", subtotal: "10.00"}})
    end

    it "returns a price" do
      expect(subject).to be_an Oshpark::Price
    end
  end

end
