require 'spec_helper'

describe Oshpark::Panel do
  subject { Oshpark::Panel.new({}) }
  it { should be_an Oshpark::Model }
  it { should be_an Oshpark::RemoteModel }
  it { should respond_to :pcb_layers }
  it { should respond_to :scheduled_order_time }
  it { should respond_to :expected_receive_time }
  it { should respond_to :id }
  it { should respond_to :ordered_at }
  it { should respond_to :received_at }
  it { should respond_to :state }
  it { should respond_to :service }
  it { should respond_to :total_orders }
  it { should respond_to :total_boards }
  it { should respond_to :board_area_in_square_mils }
end
