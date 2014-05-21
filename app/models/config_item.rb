class ConfigItem < ActiveRecord::Base
  validates_presence_of :key

  def self.[](key)
    c = ConfigItem.find_by(key: key)
    if c
      c.value || c.default
    else
      raise ActiveRecord::RecordNotFound, "config item with key #{key} not found"
    end
  end

end
