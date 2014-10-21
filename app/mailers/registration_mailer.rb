class RegistrationMailer < ActionMailer::Base
  default from: "no-reply@dasreda.ru"

  def mail_to
    Rails.configuration.registration_mail_to
  end

  # Registration done
  # @param registration [Registration] just completed registration
  def admin_notification_email(registration)
    @registration = registration
    mail(to: mail_to, subject: 'Уведомление о регистрации')
  end

  # Sms with password sending failed
  # @param registration [Registration] just completed registration
  def admin_password_sms_notifier_failed_email(registration)
    @registration = registration
    mail(to: mail_to, subject: 'Уведомление о неудачной отправке смс с паролем')
  end

  def feedback_email(params)
    @name  = params[:name]  || "Не указано"
    @phone = params[:phone] || "Не указан"
    @email = params[:email].empty? ? "no-reply@dasreda.ru" : params[:email]
    @message = params[:message]

    address = Mail::Address.new @email
    address.display_name = @name.dup
    from = address.format

    mail(to: mail_to, subject: 'Сообщение через форму обратной связи', from: from)
  end
end
