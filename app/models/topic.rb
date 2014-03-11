class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :messages, dependent: :destroy

  acts_as_taggable

  validates_presence_of :text
end
