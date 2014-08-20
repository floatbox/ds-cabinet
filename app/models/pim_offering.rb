require 'digest/sha2'

# Cached Pim offerings with prices
class PimOffering < ActiveRecord::Base
  OFFERING_ATTRIBUTES = [
    :offering_id, 
    :price_text, 
    :price_id, 
    :price_amount, 
    :price_unit, 
    :price_unit_qty 
  ]

  def attributes_hash 
    {}.tap do |hash|
      PimOffering::OFFERING_ATTRIBUTES.each {|attr| hash[attr] = self[attr]}
    end
  end

  def create_as_copy_of obj
    create(obj.attributes_hash)
  end
  
  def init
    self.code = self.code_from_string # to address by code in urls
    # ["lo.cwezYGaI8I", "loF6cL5J2gcbM", "lo2NVUXb5WWac"]
  end

  # generates ugly code from price_id to use it instead of id in urls
  def code_from_string string='lorem ipsum'
    price_id.crypt string
  end
end
