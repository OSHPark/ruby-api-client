require 'spec_helper'

describe Oshpark::Model do
  let(:klass) do
    Class.new do
      def self.attrs
        [ 'hello', 'goodbye' ]
      end
      def self.write_attrs
        [ 'bob' ]
      end

    end
  end

  describe "included" do
    before  { klass.send :include, Oshpark::Model }
    subject { klass.new({}) }

    it "class ancestors should include Oshpark::Model::ClassMethods" do
      expect(subject.class.ancestors).to include Oshpark::Model::ClassMethods
    end

    it { should respond_to :hello }
    it { should respond_to :goodbye }
    it { should respond_to :bob= }

    describe '.from_json' do
      let(:json) do
        {
          'hello'   => 'world',
          'goodbye' => 'cruel world'
        }
      end
      subject { klass.from_json json }

      its(:hello)   { should eq 'world' }
      its(:goodbye) { should eq 'cruel world' }
    end
  end
end
