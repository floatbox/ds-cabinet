namespace :users do

  desc 'Sets initial author id after AddAuthorIdToTopic migration'
  task set_initial_author_id: :environment do
    Topic.all.each do |topic|
      topic.update_column(:author_id, topic.user_id)
    end
  end

end