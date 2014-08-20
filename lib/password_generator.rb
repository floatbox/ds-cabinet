require 'keepass/password'

class PasswordGenerator
  DEFAULT_PATTERN = 'a{9}' # for patterns see http://keepass.info/help/base/pwgenerator.html
  
  @@pattern = DEFAULT_PATTERN

  def self.pattern= pattern
    @@pattern = pattern
  end

  def self.generate pattern=nil
    self.new(pattern).generate
  end

  def self.length
    self.generate.length
  end

  def initialize pattern=nil
    @pattern = pattern || @@pattern
  end

  def generate
    KeePass::Password.generate @pattern 
  end
end
