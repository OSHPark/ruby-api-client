require 'spec_helper'

describe Oshpark::Upload do
  subject { Oshpark::Upload.new({}) }
  it { should be_an Oshpark::Model }

  %w| id state original_filename error_message queued_at started_at completed_at errored_at failed_at project_id |.each do |attr|
    it { should respond_to attr }
  end

  describe '#project' do
    it 'retrieves a project' do
      allow(subject).to receive(:project_id).and_return('abcd1234')
      expect(Oshpark::Project).to receive(:find).with('abcd1234')
      subject.project
    end
  end
end
