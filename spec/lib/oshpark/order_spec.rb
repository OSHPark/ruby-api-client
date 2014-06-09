require 'spec_helper'

describe Oshpark::Order do
  subject { Oshpark::Order.new.tap { |o| o.client = FakeClient.new } }
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
      subject.stub panel_id: :panel_id
      expect(subject.client).to receive(:panel).with(:panel_id)
      subject.panel
    end
  end

  describe '#project' do
    it 'retrieves a project' do
      subject.stub project_id: :project_id
      expect(subject.client).to receive(:project).with(:project_id)
      subject.project
    end
  end
end
