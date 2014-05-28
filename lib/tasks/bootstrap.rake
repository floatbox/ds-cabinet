# This file contains rake tasks that should be run to install the application.
namespace :bootstrap do

  desc 'Create config items'
  task config_items: :environment do
    ConfigItem.find_or_create_by(key: 'search_banned_words', default: '')
    ConfigItem.find_or_create_by(key: 'registration_enabled', default: 'true')
  end

  desc 'Run all bootstrapping tasks to setup application'
  task all: [:config_items]

end