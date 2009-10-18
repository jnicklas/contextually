require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'base64'

describe 'running the specs' do
  it "should yield the currect output" do
    out = `spec #{File.expand_path('contextually_spec.rb', File.dirname(__FILE__))} --format specdoc`
    expected = File.read(__FILE__).split(Base64.decode64("X19FTkRfXw==\n")).second.strip
    out.should =~ Regexp.new(Regexp.escape(expected))
  end
end

__END__

TestsController with simple contexts as user responding to #GET index
- should respond with success

TestsController with simple contexts as visitor responding to #GET index
- should deny access

TestsController with multiple roles as visitor responding to #GET show
- should respond with success

TestsController with multiple roles as monkey responding to #GET show
- should respond with success

TestsController with multiple roles as user responding to #GET show
- should respond with success

TestsController with multiple roles as visitor GET /test responding to #GET show
- should respond with success

TestsController with multiple roles as monkey GET /test responding to #GET show
- should respond with success

TestsController with multiple roles as user GET /test responding to #GET show
- should respond with success

TestsController with multiple roles as visitor  responding to #GET show
- should respond with success

TestsController with multiple roles as monkey  responding to #GET show
- should respond with success

TestsController with multiple roles as user  responding to #GET show
- should respond with success

TestsController with only_as as user responding to #GET index
- should respond with success

TestsController with only_as as visitor responding to #GET index
- should deny access

TestsController with only_as as monkey responding to #GET index
- should deny access

TestsController with deny access as monkey responding to #GET index
- should deny access

TestsController with deny access as visitor responding to #GET index
- should deny access

TestsController with groups as visitor responding to #GET index
- should deny access

TestsController with groups as monkey responding to #GET index
- should deny access

TestsController with groups as user responding to #GET foo
- should respond with success

TestsController with groups as monkey responding to #GET foo
- should respond with success

TestsController with groups as visitor responding to #GET foo
- should deny access

TestsController with only_allow_access_to as visitor responding to #GET index
- should deny access

TestsController with only_allow_access_to as monkey responding to #GET index
- should deny access
