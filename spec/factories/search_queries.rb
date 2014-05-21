# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_query do
    user_id 1
    text "MyText"
  end
end
