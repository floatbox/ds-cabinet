PHONE_VALID = '7441111111'
PHONE_VALID_CONFIRMATION = '+77441111111'
OGRN_VALID  = '306770000348481'
OGRN_VALID_FIRST_NAME = 'Ольга Анатольевна'
OGRN_VALID_LAST_NAME  = 'Батурина'
OGRN_VALID_PASSWORD = "180"
INTEGRATION_ID = "UAS100173"
CONTACT_ID = "1-1WMYU0"

Если(/^отсутствует объект модели регистрации$/) do
  Registration.find_by_ogrn(OGRN_VALID).should_not be
end

Если(/^имеется объект модели регистрации$/) do
#  r = nil
#  wait_up_to 120.seconds do
#    puts "waiting for registration object creation"
#    r = Registration.find_by_ogrn(OGRN_VALID)
#  end

  r = Registration.find_by_ogrn(OGRN_VALID)
  r.should be
  r.password.should_not be_empty
  r.inn.should_not be_empty
end

Если(/^указывает телефон, прежде не использовавшийся для регистрации$/) do
  @phone = PHONE_VALID
  step %Q(пользователь заполняет поле ввода "Введите телефон" в форме регистрации и входа значением "#{@phone}")
end

Если(/^указывает существующий ОГРН, прежде не использовавшийся для регистрации$/) do
  @ogrn = OGRN_VALID
  step %Q(пользователь заполняет поле ввода "Введите ОГРН" в форме регистрации и входа значением "#{@ogrn}")
end

Если(/^начинает регистрацию$/) do
  VCR.use_cassette("#{@phone}-#{@ogrn}") do
    step %Q(пользователь кликает кнопку "Зарегистрироваться" в форме регистрации и входа)
    step "Ajax запрос выполняется"
    step "ждать завершения всех Ajax запросов"
  end
end

Если(/^(|отмена ?)компании в Siebel не существует$/) do |negation|
  #allow(Registration.any_instance).to receive(:siebel_company_exists?).and_return(false)
  if negation == "отмена "
    Account.unstub(:where)
  else
    allow(Account).to receive(:where).and_return([])
  end
end

Если(/^(|отмена ?)контакт в Siebel существует$/) do |negation|
  if negation == "отмена "
    Contact.unstub(:find_by_integration_id)
  else
    Contact.stub :find_by_integration_id do
      Object.new.tap.define_singleton_method :id do
        CONTACT_ID
      end
    end
  end
end

Если(/^правильно заполняет ОГРН и телефон и переходит к следующему шагу$/) do
  step("указывает телефон, прежде не использовавшийся для регистрации")
  step("указывает существующий ОГРН, прежде не использовавшийся для регистрации")
  step("начинает регистрацию")
  step("имеется объект модели регистрации")
end

То(/^видит правильные регистрационные данные$/) do
  within(area_to_selector("форма подтверждения регистрации")) do
    find('.js-registration_ogrn'      ).text.should eq(OGRN_VALID)
    find('.js-registration_first_name').text.should eq(OGRN_VALID_FIRST_NAME)
    find('.js-registration_last_name' ).text.should eq(OGRN_VALID_LAST_NAME)
    find('.js-registration_phone'     ).text.should eq(PHONE_VALID_CONFIRMATION)
  end
end

То(/^получает смс с паролем$/) do
  @password = Registration.last.password
  @password.should_not be_empty
end

То(/^вводит (|не?)правильный пароль$/) do |negation|
  within(area_to_selector("форма подтверждения регистрации")) do
    fill_in 'password', with: (negation == 'не' ? 'wrong password' : @password)
  end
end

То(/^подтверждает регистрацию(| неудачно?)$/) do |effect|
  VCR.use_cassette("#{@phone}-#{@ogrn}") do
    step %Q(пользователь кликает кнопку "Дальше" в форме подтверждения регистрации)
    unless effect == " неудачно"
      step "Ajax запрос выполняется"
      step "ждать завершения всех Ajax запросов"
    end
  end
end

То(/^генератор паролей возвращает пароль "(.*?)"$/) do |given_password|
  allow(PasswordGenerator).to receive(:generate).and_return(given_password)
end

То(/^генератор паролей возвращает правильный пароль/) do
  step %Q(генератор паролей возвращает пароль "#{OGRN_VALID_PASSWORD}")
end

Если(/^проверяет свои ОГРН, телефон и имя, вводит пароль и переходит к следующему шагу$/) do
  step "контакт в Siebel существует"
  #step("отмена компании в Siebel не существует")
  step %Q(скриншот "registration - confirmation start")
  step "видит правильные регистрационные данные"
  step "получает смс с паролем"
  #step "проверяет работу кнопки Отправить данные еще раз"
  #step "вводит правильный пароль"

  # Проверка пустого и неправильного пароля
  step "подтверждает регистрацию неудачно"
  step "вводит неправильный пароль"
  step "подтверждает регистрацию"
  step %Q(появляется сообщение об ошибке "Пароль: неправильный")
  step %Q(скриншот "registration - confirmation bad password")
  step "закрывает сообщение"

  # Проверка повторной отправки пароля
  #step "проверяет работу ссылки Отправить еще раз"
  
  step %Q(скриншот "registration - confirmation finish")
  step "вводит правильный пароль"
  step "подтверждает регистрацию"
  step "отмена контакт в Siebel существует"
  step %Q(скриншот "registration - payment start")
end
