class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, polymorphic: true

  serialize :data
  default_scope { order('created_at DESC') }
  scope :unread, -> { where(read_at: nil) }
end
