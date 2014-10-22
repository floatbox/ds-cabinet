DsCabinet::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener

  config.registration_mail_to = 'legko_team@dasreda.ru'

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.precompile += %w( *.js )

  # Project-specific options
  config.sms_gateway = 'https://api.sredda.ru:4444/SMSGateway/sms'

#  # UAS settings
#  config.uas_url = 'https://pim.sredda.ru:4443/authentication'
#  config.uas_sertificate = "#{Rails.root}/certs/ds_admin.pem"
#  config.uas_query_log = true
#
#  # PIM settings
#  config.pim_url = 'https://pim.sredda.ru:4443'
#  config.pim_sertificate = "#{Rails.root}/certs/ds_admin.pem"
#  config.pim_product_offerings = ['5336743']
#  config.pim_product_url = 'http://dsstore.dasreda.ru/'
#  config.pim_query_log = true
#  config.pim_curl_verbose = true
#
#  # CART settings
#  config.cart_url = 'http://cart.sredda.ru'
#  config.cart_sertificate = "#{Rails.root}/certs/ds_admin.pem"
#  config.cart_merchant_id = '100004'
#  config.cart_merchant_password = 'password4'
#  config.cart_query_log = true
#  config.cart_curl_verbose = true

  # UAS settings
  config.uas_url = 'https://ccdemopim.sredda.ru:5443/authentication'
  config.uas_sertificate = "#{Rails.root}/certs/ds_user.pem"
  config.uas_query_log = true

  # PIM settings
  config.pim_url = 'https://ccdemopim.sredda.ru:5443'
  config.pim_sertificate = "#{Rails.root}/certs/ds_user.pem"
  config.pim_product_offerings = ['3000319']
  config.pim_product_url = 'http://dsstore.dasreda.ru/'
  config.pim_query_log = true
  config.pim_curl_verbose = true

  # CART settings
  config.cart_url = 'https://cart-delo.sredda.ru:5443'
  config.cart_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.cart_merchant_id = '400004'
  config.cart_merchant_password = 'cArt123QWE123'
  config.cart_query_log = true
  config.cart_curl_verbose = true

  # Authentication settings
  config.auth_domain = nil # domain for auth_token cookie not applicable to localhost

  # Widgets settings
  config.widget_script_url = 'http://delo-widgets-dev.sredda.ru:8082/assets/lib/widget.js'
  config.widget_domain = 'delo-widgets-dev.sredda.ru:8082'
end
