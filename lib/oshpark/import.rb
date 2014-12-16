module Oshpark
  class Import
    def self.attrs
      %w| id state original_url original_filename error_message queued_at started_at completed_at errored_at failed_at project_id |
    end

    include Model

    def self.create url
      self.from_json(Oshpark::client.create_import(url)['import'])
    end

    def project
      Project.find project_id
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
