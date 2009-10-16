$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
$:.unshift(File.dirname(__FILE__))

require 'rubygems'

require 'action_pack'
require 'action_controller'
require 'active_support'
require 'initializer'

require 'spec'
require 'spec/autorun'
require 'spec/rails'

require 'remarkable_rails'

require 'contextually'
