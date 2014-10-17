REGISTRATION_OFFERINGS = [{
        :offering_id => "3000319",
  :offering_price_id => "3000329",
               :text => "3 месяца",
             :amount => 2400.0,
               :unit => "Month",
           :unit_qty => 3
},
{
        :offering_id => "3000319",
  :offering_price_id => "3000336",
               :text => "12 месяцев",
             :amount => 7200.0,
               :unit => "Month",
           :unit_qty => 12,
               :type => "RegistrationOffering",
},
{
        :offering_id => "3000319",
  :offering_price_id => "3000343",
               :text => "1 месяц",
             :amount => 10.0,
               :unit => "Month",
           :unit_qty => 1,
               :type => "RegistrationOffering",
}]

Before do |scenario|
  load Rails.root.join('db/seeds.rb')
  REGISTRATION_OFFERINGS.each do |ro|
    RegistrationOffering.where(ro).first_or_create
  end
end
