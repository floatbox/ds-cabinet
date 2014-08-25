require 'digest/sha2'

# Cached Pim offerings with prices
class PimOffering < ActiveRecord::Base
  OFFERING_ATTRIBUTES = [
    :offering_id,
    :offering_price_id,
    :text,     
    :unit,     # пока одно значение - "Month"
    :unit_qty, # кол-во периодов, например, 3
    :amount    # стоимость в рублях за кол-во периодов
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
    offering_price_id.crypt string
  end

  def offering_url
    'http://market.yandex.ru/model-spec.xml?modelid=10890865&hid=6427100'
  end
end
