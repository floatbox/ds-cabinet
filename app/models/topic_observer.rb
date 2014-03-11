class TopicObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  def after_create(record)
    if record.user.concierge
      Notification.create(
        user: record.user.concierge,
        name: 'topic_created',
        data: { 
          id: record.id,
          link: concierge_topic_path(record),
          text: "#{record.user.siebel.full_name} создал топик \"#{truncate(record.text, length: 17, separator: ' ')}\""
        }
      )
    end
  end
end