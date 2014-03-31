class Topic < ActiveRecord::Base
  include Notificationable

  belongs_to :user
  has_many :messages, dependent: :destroy

  acts_as_taggable

  validates :text, presence: true, length: { maximum: 100 }

end
