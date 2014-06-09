require 'spec_helper'

describe Oshpark::Layer do
  it { should be_an Oshpark::Model }
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :gerber_file_url }
  it { should respond_to :image }
  it { should respond_to :imported_from }
  it { should respond_to :width_in_mils }
  it { should respond_to :height_in_mils }
  it { should respond_to :image }
end
