class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates_presence_of :text
end
