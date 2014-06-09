require 'spec_helper'

describe Oshpark::Project do
  it { should respond_to(:name) }
  it { should respond_to(:name=) }

end
