# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :config_item do
    key "MyString"
    value "MyText"
  end
end
