class RegistrationMailer < ActionMailer::Base
  default from: "no-reply@dasreda.ru"

  # Registration done
  # @param registration [Registration] just completed registration
  def admin_notification_email(registration)
    @registration = registration
    mail(to: 'Legko_support@dasreda.ru', subject: 'Уведомление о регистрации')
  end

  # Sms with password sending failed
  # @param registration [Registration] just completed registration
  def admin_password_sms_notifier_failed_email(registration)
    @registration = registration
    mail(to: 'Legko_support@dasreda.ru', subject: 'Уведомление о неудачной отправке смс с паролем')
  end

  def feedback_email(params)
    @name  = params[:name]  || "Не указано"
    @phone = params[:phone] || "Не указан"
    @email = params[:email] || "no-reply@dasreda.ru"
    @message = params[:message]

    address = Mail::Address.new @email
    address.display_name = @name.dup
    from = address.format
    
    mail(to: 'Legko_support@dasreda.ru', subject: 'Сообщение через форму обратной связи', from: from)
  end
end
