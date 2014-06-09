require 'spec_helper'

describe Oshpark::Oshpark do
  let(:client) { FakeClient.new }
  subject { Oshpark::Oshpark.new client: client }

  it { should be }

end
