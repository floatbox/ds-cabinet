namespace :users do

  desc 'Sets initial author id after AddAuthorIdToTopic migration'
  task set_initial_author_id: :environment do
    Topic.all.each do |topic|
      topic.update_column(:author_id, topic.user_id)
    end
  end

  desc 'Resets API tokens for all the users'
  task reset_api_token: :environment do
    User.all.each do |user|
      user.reset_api_token
    end
  end

  desc 'Clear topics and messages for all the users'
  task clear_topics: :environment do
    Topic.destroy_all
    Notification.delete_all
    Attachment.delete_all
  end

end
