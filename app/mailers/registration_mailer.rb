class RegistrationMailer < ActionMailer::Base
   default from: "no-reply@dasreda.ru"

  # Registration done
  # @param registration [Registration] just completed registration
  def admin_notification_email(registration)
    @registration = registration
    mail(to: 'Legko_support@dasreda.ru', subject: 'Уведомление о регистрации')
  end
end
