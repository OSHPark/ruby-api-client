module Oshpark
  class Upload
    def self.attrs
      %w| id state original_filename error_message queued_at started_at completed_at errored_at failed_at project_id |
    end

    include Model

    def self.create file
      self.from_json(Oshpark::client.create_upload(file))
    end

    def project
      Project.find project_id
    end

    def processing?
      %w| WAITING RUNNING |.member? state
    end

    def finished?
      %w| SUCCESS ERROR FAILED |.member? state
    end

    %w| WAITING RUNNING SUCCESS ERROR FAILED |.each do |_state|
      define_method "#{_state.downcase}?" do
        state == _state
      end
    end

    def queued_at
      time_from @queued_at
    end

    def started_at
      time_from @started_at
    end

    def completed_at
      time_from @completed_at
    end

    def errored_at
      time_from @errored_at
    end

    def failed_at
      time_from @failed_at
    end
  end
end
