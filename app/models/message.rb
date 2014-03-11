class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  has_and_belongs_to_many :attachments

  validates_presence_of :text
end
