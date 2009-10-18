module Contextually
  VERSION = '0.1'
  
  class UndefinedContext < StandardError; end
end

require 'contextually/example_extension'
require 'contextually/definition'
