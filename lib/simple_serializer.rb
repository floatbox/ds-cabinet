# Adds serialization support to class, serialises all instant variables 
# base.extend
module SimpleSerializer
  # Serialization to store object in Registration#uas_user attribute

  def dump obj
    return nil if obj.nil?

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
    string.nil? ? nil : YAML.load(string)
  end
end
