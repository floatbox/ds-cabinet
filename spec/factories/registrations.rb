# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration do
    sequence(:phone) { |i| "+#{i.to_s.rjust(11, '0')}" }
    ogrn '1127746082903'
    workflow_state 'done'
    password 'qwerty123'
    password_confirmation 'qwerty123'

    factory :awaiting_verification_registration do
      workflow_state 'awaiting_verification'
    end

    factory :awaiting_password_registration do
      workflow_state 'awaiting_password'
    end

    factory :verified_and_deferred_registration do
      workflow_state 'verified_and_deferred'
    end
  end
end
