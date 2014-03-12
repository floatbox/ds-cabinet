module Notificationable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :object, dependent: :destroy
  end

  module ClassMethods
  end

end