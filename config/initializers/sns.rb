Ds::Sns::configure :development, :test do
  log :all
end

Ds::Sns.configure :development, :test do
  certificate "#{Rails.root}/certs/ds_admin.pem"
  service :social_network, 'https://sns.sredda.ru:4443/socialNetwork2'
  service :authorization, 'https://sns.sredda.ru:4443/authorization'
  logger Rails.logger
  super_user '1-4DFE', 'siebel'
end

Ds::Sns.configure :staging do
  certificate "#{Rails.root}/certs/ds_admin.pem"
  service :social_network, 'https://sns.sredda.ru/socialNetwork2'
  service :authorization, 'https://sns.sredda.ru/authorization'
  logger Rails.logger
  super_user '1-4DFE', 'siebel'
end

Ds::Sns.configure :production do
  certificate "#{Rails.root}/certs/ds_admin.pem"
  service :social_network, 'https://sns.dasreda.ru/socialNetwork2'
  service :authorization, 'https://sns.dasreda.ru/authorization'
  logger Rails.logger
  super_user '1-4DFE', 'siebel'
end
