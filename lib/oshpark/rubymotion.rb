unless defined?(Motion::Project::Config)
  raise "The oshpark gem must be required within a RubyMotion project Rakefile."
end


Motion::Project::App.setup do |app|
  lib = File.expand_path(__FILE__, "../../")
  app.files = Dir.glob("#{lib}/**/*.rb") + app.files
end
