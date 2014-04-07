# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    user { User.find_or_create_by(integration_id: USERS[:user_1][:integration_id]) }
    text 'Just another one topic'
  end
end
