class Attempt::RegistrationPasswordNotification < Attempt::Base

  after_initialize :defaults

  def defaults
    self.limit = 3
    self.timeout = 60.seconds
  end
end
