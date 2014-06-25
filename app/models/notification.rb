class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, polymorphic: true

  serialize :data
  default_scope { order('created_at DESC') }
  scope :unread, -> { where(read_at: nil) }

  after_create :send_sms

  private

    def send_sms
      Dsreda::Sms.send(user.phone, text: sms_text) unless user.online?
      true
    end

    # @return [String] notification text for SMS representation
    def sms_text
      I18n.t("notifications.sms.#{name}", options_for_sms_text)
    end

    # @return [Hash] data for SMS text placeholders
    def options_for_sms_text
      case name
      when 'message_created', 'message_updated'
        { user: object.user.siebel.full_name,
          message: object.text.truncate(17, separator: ' '),
          topic: object.topic.text.truncate(10, separator: ' ') }
      when 'topic_created', 'topic_updated'
        { user: object.author.siebel.full_name,
          topic: object.text.truncate(17, separator: ' ') }
      when 'user_created', 'user_attached'
        { user: object.siebel.full_name }
      else {}
      end
    end
end
