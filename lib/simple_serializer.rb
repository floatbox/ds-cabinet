# Adds serialization support to class, serialises all instant variables 
# base.extend
module SimpleSerializer
  # Serialization to store object in Registration#uas_user attribute

  def dump obj
    return nil if obj.nil?

    if obj.is_a?(self)
      obj.to_yaml
    else
      raise ::ActiveRecord::SerializationTypeMismatch,
        "Attribute was supposed to be a #{self}, but was a #{obj.class}. -- #{obj.inspect}"
    end
  end

  def load string
    string.nil? ? nil : YAML.load(string) 
  end
end
