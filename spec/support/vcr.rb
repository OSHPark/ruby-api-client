require 'dotenv'
Dotenv.load

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path('../../fixtures/cassettes/', __FILE__)
  config.hook_into :webmock

  config.filter_sensitive_data('<USERNAME>') { ENV['USERNAME'] }
  config.filter_sensitive_data('<PASSWORD>') { ENV['PASSWORD'] }
  config.filter_sensitive_data('<PROJECT>')  { ENV['PROJECT']}
end

module SwitchCassette
  def self.extended base
    base.around(:each) do |example|
      VCR.use_cassette example.example_group.name.strip, &example
    end
  end
end
