PHONE_VALID = '7441111111'
OGRN_VALID  = '306770000348481'

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

Если(/^компании в Siebel не существует$/) do
  #allow(Registration.any_instance).to receive(:siebel_company_exists?).and_return(false)
  allow(Account).to receive(:where).and_return([])
end

Если(/^правильно заполняет ОГРН и телефон и переходит к следующему шагу$/) do
  step("компании в Siebel не существует")
  step("указывает телефон, прежде не использовавшийся для регистрации")
  step("указывает существующий ОГРН, прежде не использовавшийся для регистрации")
  step("начинает регистрацию")
  step("имеется объект модели регистрации")
end
