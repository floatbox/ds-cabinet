DsCabinet::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_assets  = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Project-specific options
  config.sms_gateway = 'https://api.sredda.ru:4444/SMSGateway/sms'

  # PIM settings
  config.pim_url = 'https://pim.sredda.ru:4443'
  config.pim_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.pim_product_offerings = ['5336743']
  config.pim_product_url = 'http://dsstore.dasreda.ru/'
  config.pim_query_log = true
  config.pim_curl_verbose = true

  # CART settings
  config.cart_url = 'http://cart.sredda.ru'
  config.cart_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.cart_merchant_id = '100004'
  config.cart_merchant_password = 'password4'
  config.cart_query_log = true
  config.cart_curl_verbose = true

  # UAS settings
  config.uas_url = 'https://pim.sredda.ru:4443/authentication'
  config.uas_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.uas_query_log = true

  # Authentication settings
  config.auth_domain = nil # domain for auth_token cookie not applicable to localhost

  # Widgets settings
  config.widget_script_url = 'http://delo-widgets-dev.sredda.ru:8082/assets/lib/widget.js'
  config.widget_domain = 'delo-widgets-dev.sredda.ru:8082'
end
