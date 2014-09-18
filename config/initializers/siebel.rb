Ds::Siebel.configure :test, :development do
  url 'https://siebel.dasreda.ru:9443'
  login 'Club'
  password 'Xxrhvdlz'
  wsdl_path "#{Rails.root}/data/wsdl_development"
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
