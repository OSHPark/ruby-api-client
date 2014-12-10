require 'pry'
require 'oshpark'

require 'rspec/its'
require 'byebug'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  # config.color_enabled = true
  config.formatter = :documentation
end
