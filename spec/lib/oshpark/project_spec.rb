require 'spec_helper'

describe Oshpark::Project do
  subject { Oshpark::Project.new({}) }
  it { should be_an Oshpark::Model }
  it { should be_an Oshpark::RemoteModel }
  it { should respond_to(:name) }
  it { should respond_to(:name=) }

end
