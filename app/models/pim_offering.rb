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
end
