require 'spec_helper'

describe Oshpark::Image do
  it { should be_an Oshpark::Model }
  it { should respond_to :thumb_url }
  it { should respond_to :large_url }
  it { should respond_to :original_url }
end
