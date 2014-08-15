# Adds serialization support to class, serialises all instant variables 
# base.extend
module SimpleSerializer
  # Serialization to store object in Registration#uas_user attribute

  def dump obj
    return nil.to_yaml if obj.nil?

    unless obj.is_a?(self)
      raise ::ActiveRecord::SerializationTypeMismatch,
        "Attribute was supposed to be a #{self}, but was a #{obj.class}. -- #{obj.inspect}"
    end
    
    {}.tap do |hash|
      obj.instance_variables.each do |var|
        hash[var] = obj.instance_variable_get(var)
      end
    end.to_yaml
  end

  def load string
    string.nil? ? nil : self.new.tap do |user|
      (YAML.load(string) || {}).each do |key, value|
        user.instance_variable_set(key, value)
      end
    end
  end
end
