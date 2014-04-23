class Topic < ActiveRecord::Base
  include Notificationable
  include Readable

  WIDGET_TYPES = %w(purchase)

  serialize :widget_options, JSON

  # @return [User] user this topic is related to
  belongs_to :user

  # @return [User] the creator of this topic
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many :messages, dependent: :destroy

  acts_as_taggable

  before_validation :set_author_id, unless: :author_id
  before_validation :set_text, if: :widget_type
  before_validation :fix_newlines

  validates :text, presence: true, length: { maximum: 1200 }
  validates :widget_type, inclusion: { in: WIDGET_TYPES }, if: :widget_type

  default_scope { order('created_at DESC') }

  private

    # By default author_id is the same as user_id
    # author_id should be overwritten in controller if it is not true
    def set_author_id
      self.author_id = user_id
    end

    # Set fake text if it is topic with widget
    def set_text
      self.text = widget_type
    end

    def fix_newlines
      self.text = text.gsub("\r\n","\n") if self.text
    end

    # Automatically read all the messages
    def after_read_by(user)
      messages.each { |m| m.read_by(user) }
    end

end
