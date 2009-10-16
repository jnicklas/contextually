class Contextually
  VERSION = '0.0.1'
  
  class UndefinedContext < StandardError; end
  
  module ClassMethod
    def only_as(*args, &block)
      as(*args, &block)
      roles, params = extract_params(args)
      deny_params = Contextually.roles.keys - roles
      deny_params.push(params)
      deny_access_to(*deny_params)
    end
    
    def as(*args, &block)
      roles, params = extract_params(args)
      roles.each do |role|
        context "as #{role}" do
          before(&Contextually.before(role))
          describe(params.dup, &block)
        end
      end
    end
    
    def deny_access_to(*args)
      roles, params = extract_params(args)
      roles.each do |role|
        block = Contextually.deny_access(role)
        if block
          context "as #{role}" do
            before(&Contextually.before(role))
            describe(params.dup, &block)
          end
        else
          raise Contextually::UndefinedContext, "don't know how to deny access to a #{role}"
        end
      end
    end
    
  private
  
    def extract_params(args)
      if args.blank? or args.last.is_a?(Symbol) 
        params = ""
      else
        params = args.pop
      end
      args = args.inject([]) { |array, role| array.push(*Contextually.groups[role] || role); array }
      return args, params
    end
  end
  
  class Role < Struct.new(:name, :before, :deny_access); end
  
  class << self
    attr_accessor :roles, :deny_access_to_all
    
    def context
      @context ||= Contextually.new
    end
    
    def groups
      @groups ||= {}
    end
    
    def role(role)
      unless roles and roles.has_key?(role)
        raise Contextually::UndefinedContext, "no role called #{role.inspect} exists"
      end
      roles[role]
    end
    
    def before(role)
      role(role).before
    end
    
    def deny_access(role)
      role(role).deny_access || deny_access_to_all
    end
    
    def define(&block)
      context.define(&block)
    end

  end
  
  def define(&block)
    instance_eval(&block)
  end
  
  def roles(*roles)
    Contextually.roles = roles.inject({}) { |hash, role| hash[role] = Role.new(role); hash }
  end
  
  def group(*roles, &block)
    as = roles.pop[:as]
    Contextually.groups[as] = roles
  end
  
  def before(name, &block)
    Contextually.roles[name].before = block
  end
  
  def deny_access_to(name, &block)
    Contextually.roles[name].deny_access = block
  end
  
  def deny_access(&block)
    Contextually.deny_access_to_all = block
  end
  
end

Spec::Rails::Example::ControllerExampleGroup.send(:extend, Contextually::ClassMethod) if defined?(Spec)