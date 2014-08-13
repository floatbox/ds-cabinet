namespace :registrations do

  # See config entry in config/environments/development.rb
  # config.pim_product_offerings = ['3000319']
  desc 'Reloads offerings for registration payments, specified in Rails config'
  task reload_offerings: :environment do
    Rails.configuration.pim_product_offerings.each do |offering_id|
      RegistrationOffering.reload_from_pim offering_id
    end
  end
end
