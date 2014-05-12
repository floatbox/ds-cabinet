namespace :registrations do

  desc 'Find registrations that were not sent to admin as notifications'
  task find_not_notified: :environment do
    registrations = Registration.where(workflow_state: [:awaiting_verification, :awaiting_password, :done]).
                                 where(admin_notified: false).
                                 where('updated_at <= ?', 15.minutes.ago)
    registrations.each(&:notify_admin)
  end

end