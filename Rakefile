require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'

$:.unshift(File.expand_path('lib', File.dirname(__FILE__)))
require 'contextually'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'contextually' do
  self.developer 'Jonas Nicklas', 'jonas.nicklas@gmail.com'
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['remarkable_rails','>= 3.1.10']]
  self.version = Contextually::VERSION
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
