# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# The application refuses to function w/o these config items 
ConfigItem.create key: 'registration_enabled', value: 'true'
ConfigItem.create key: 'search_banned_words',  value: nil
