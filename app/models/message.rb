class Message < ActiveRecord::Base
  include Notificationable

  belongs_to :topic
  belongs_to :user

  has_and_belongs_to_many :attachments

  validates :text, presence: true, length: { maximum: 1000 }

  default_scope { order('created_at ASC') }
end
