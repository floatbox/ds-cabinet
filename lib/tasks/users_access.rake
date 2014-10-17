namespace :users do

  # See config entry in config/environments/development.rb
  # config.pim_product_offerings = ['3000319']
  desc 'Creates access purchase for given user and offering price id and makes it paid'
  task :access_paid, [:user_id, :offering_price_id] => :environment do |t, args|
    puts "Running for user id=#{args[:user_id]} and offering_price_id=#{args[:offering_price_id]}"
    user = User.find_by_id args[:user_id]
    ro = RegistrationOffering.find_by_offering_price_id args[:offering_price_id]
    if user && ro
      if user.has_paid_access?
        puts "The user with id=#{user.id} already has paid access"
      else
        user.access_purchases.not_paid.destroy_all
        ap = user.access_purchases.create(ro.attributes_hash)
        order = ap.create_order
        order.update_column :payment_date, Time.now
        puts "Set access paid for user with id=#{user.id}"
      end
    else
      puts "Not found user" unless user
      puts "Not found offering_price" unless ro
    end
  end

  desc 'Lists all users and all offerings'
  task access_show_all: :environment do |t, args|
    puts "Running for user id=#{args[:user_id]} and offering_price_id=#{args[:offering_price_id]}"
    puts "USERS:"
    User.all.each do |user|
      puts user.inspect
    end

    puts "REGISTRATION OFFERINGS:"
    RegistrationOffering.all.each do |ro|
      puts "offering_price_id=%s amount=%7.2f text='%10s' unit=%6s qty=%02i"%[ro.offering_price_id, ro.amount, ro.text, ro.unit, ro.unit_qty]
    end
  end
end
