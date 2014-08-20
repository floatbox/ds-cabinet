Ds::Siebel.configure :test, :development do
  url 'https://sbldev.dasreda.ru:8443'
  login 'testuser01'
  password '1234'
  wsdl_path "#{Rails.root}/data/wsdl"
end

Ds::Siebel.configure :staging do
  url 'https://siebel.dasreda.ru'
  login 'Club'
  password 'Xxrhvdlz'
  wsdl_path "#{Rails.root}/data/wsdl_production"
end

Ds::Siebel.configure :production do
  url 'https://siebel.dasreda.ru:443'
  login 'Club'
  password 'Xxrhvdlz'
  wsdl_path "#{Rails.root}/data/wsdl_production"
end