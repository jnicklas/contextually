module Contextually
  class Role < Struct.new(:name, :before, :deny_access); end

  class Definition
    def self.define(&block)
      self.new.instance_eval(&block)
    end
  
    def roles(*roles)
      Contextually.roles = roles.inject({}) { |hash, role| hash[role] = Contextually::Role.new(role); hash }
    end
  
    def group(*roles, &block)
      as = roles.pop[:as]
      Contextually.groups[as] = roles
    end
  
    def before(name, &block)
      Contextually.roles[name].before = block
    end

    def before_all(&block)
      Contextually.before_all = block
    end
  
    def deny_access_to(name, &block)
      Contextually.roles[name].deny_access = block
    end
  
    def deny_access(&block)
      Contextually.deny_access_to_all = block
    end
  end
  
  class << self
    attr_accessor :roles, :deny_access_to_all, :before_all
    
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
      Contextually::Definition.define(&block)
    end
  end
end
