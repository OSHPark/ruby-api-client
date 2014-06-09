require 'spec_helper'

describe Oshpark::Model do
  let(:klass) do
    Class.new do
       def self.attrs
        [ :hello, :goodbye ]
      end
    end
  end

  describe "included" do
    before { klass.send :include, Oshpark::Model }
    subject { klass.new }

    it "class ancestors should include Oshpark::Model::ClassMethods" do
      expect(subject.class.ancestors).to include Oshpark::Model::ClassMethods
    end

    it { should respond_to :hello }
    it { should respond_to :hello= }
    it { should respond_to :goodbye }
    it { should respond_to :goodbye= }
  end
end
