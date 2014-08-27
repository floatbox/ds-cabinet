# Access purchase record
require 'ds/purchase/order'

class AccessPurchase< Purchase
  delegate :integration_id, :to => :user, :allow_nil => false
end
