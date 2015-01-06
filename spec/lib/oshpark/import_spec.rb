require 'spec_helper'

describe Oshpark::Import do
  subject { Oshpark::Import.new({}) }
  it { should be_an Oshpark::Model }
  it { should be_an Oshpark::RemoteModel }

  %w| id state original_url original_filename error_message queued_at started_at completed_at errored_at failed_at project_id |.each do |attr|
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

