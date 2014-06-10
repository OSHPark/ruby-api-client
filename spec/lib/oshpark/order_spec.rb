require 'spec_helper'

describe Oshpark::Order do
  subject { Oshpark::Order.new({}) }
  it { should be_an Oshpark::Model }
  it { should respond_to :id }
  it { should respond_to :board_cost }
  it { should respond_to :cancellation_reason }
  it { should respond_to :cancelled_at }
  it { should respond_to :ordered_at }
  it { should respond_to :payment_provider }
  it { should respond_to :payment_received_at }
  it { should respond_to :project_name }
  it { should respond_to :quantity }
  it { should respond_to :shipping_address }
  it { should respond_to :shipping_cost }
  it { should respond_to :shipping_country }
  it { should respond_to :shipping_method }
  it { should respond_to :shipping_name }
  it { should respond_to :state }
  it { should respond_to :total_cost }
  it { should respond_to :project_id }
  it { should respond_to :panel_id }

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
end
