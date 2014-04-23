class Message < ActiveRecord::Base
  include Notificationable
  include Readable

  belongs_to :topic
  belongs_to :user

  has_and_belongs_to_many :attachments

  before_validation :fix_newlines
  after_create :read_topic

  validates :text, presence: true, length: { maximum: 1200 }

  default_scope { order('created_at ASC') }

  private

    def fix_newlines
      self.text = text.gsub("\r\n","\n") if self.text
    end

    # Tries to mark the topic as read by the user who posted the message
    def read_topic
      topic.read_by(user)
    end
end
