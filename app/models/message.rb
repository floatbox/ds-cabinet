class Message < ActiveRecord::Base
  include Notificationable
  include Readable

  belongs_to :topic
  # @return [User] user this message is related to
  belongs_to :user

  # @return [User] the creator of this message
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_and_belongs_to_many :attachments

  before_validation :fix_newlines
  # after_create :read_topic

  validates :text, presence: true, length: { maximum: 1200 }

  # default_scope { order('created_at ASC') }
  default_scope { order('created_at DESC') }
  scope :published, -> { where('created_at IS NOT NULL') }

  private

    def fix_newlines
      self.text = text.gsub("\r\n","\n") if self.text
    end

    # Tries to mark the topic as read by the user who posted the message
    def read_topic
      topic.read_by(user)
    end
end
