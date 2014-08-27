require 'dsreda/sms'

class PasswordSmsNotifier
  def initialize phone, password
    @phone, @password = phone, password
  end

  # @return[Boolean|String] Возвращает какой-то числовой код в случае успешной
  #   отправки sms и false в случае неудачной попытки
  #
  def send
    options = { text: self.text }
    Dsreda::Sms.send @phone, options
  end

  def text
    "Для входа на сайт используйте\nлогин: #{@phone}\nпароль #{@password}"
  end
end
