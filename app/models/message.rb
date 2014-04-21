class Message < ActiveRecord::Base
  include Notificationable

  belongs_to :topic
  belongs_to :user

  has_and_belongs_to_many :attachments

  before_validation :fix_newlines

  validates :text, presence: true, length: { maximum: 1200 }

  default_scope { order('created_at ASC') }

  private

    def fix_newlines
      self.text = text.gsub("\r\n","\n") if self.text
    end
end
