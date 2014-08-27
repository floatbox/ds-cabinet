require 'password_generator'
config = YAML.load_file(File.join(Rails.root, 'config/password_generator.yml'))[Rails.env]
PasswordGenerator.pattern= config["pattern"]
