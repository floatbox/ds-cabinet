class Presets
  REGISTRATION_PRESETS = { 
    # Набор данных для успешного прохождения регистрации от начала и до конца
    "Батурина" => { 
      ogrn:               '306770000348481',
      phone:                '7441111111',
      phone_confirmation: '+77441111111',
      first_name:         'Ольга Анатольевна',
      last_name:          'Батурина',
      password:           '180',
      integration_id:     'UAS100173',
      contact_id:         '1-1WMYU0',
      siebel_id:          '1-1WMYU0',
      inn:                '771607534337',
      region_code:        '45',
      offering_id:        '3000319',
      offering_price_id:  '3000329',
      user_id:            1,
      contact_model_stub: (Class.new.tap.define_singleton_method :find_by_integration_id do |integration_id|
                            Object.new.tap.define_singleton_method :id do
                              '1-1WMYU0'
                            end
                          end),
      account_model_stub: (Class.new.tap.define_singleton_method :find_by_integration_id do
                            Object.new.tap.define_singleton_method :id do
                              '1-1WMYUL'
                            end.tap.define_singleton_method :full_name do
                              'Батурина Ольга Анатольевна'
                            end
                          end.tap.define_singleton_method :where do |*args|
                            [(Object.new.tap.define_singleton_method :id do
                              '1-1WMYUL'
                            end.tap.define_singleton_method :full_name do
                              'Батурина Ольга Анатольевна'
                            end)]
                          end)
    }
  }
 
  def self.cassette
    "%s-%s"%[self.current[:phone], self.current[:ogrn]]
  end

  def self.current= key
    @@current = key
  end

  def self.current
    REGISTRATION_PRESETS[@@current]
  end
end

Если(/^используется пресет "(.*?)"$/) do |preset|
  Presets.current = preset
  Presets.current.should be
end

Если(/^(отсутствует|имеется|подтвержден|завершен) объект модели регистрации$/) do |state|
  @registration = Registration.find_by_ogrn(Presets.current[:ogrn])
  if state == "отсутствует"
    @registration.should_not be
  elsif state == "имеется"
    @registration.workflow_state.should == "awaiting_confirmation"
    @registration.admin_notified.should eq false
    @registration.user_id.should        eq nil
    @registration.contact_id.should     eq nil
    @registration.person_id.should      eq nil
  elsif state == "подтвержден"
    @registration.workflow_state.should == "awaiting_payment"
    step "к регистрации не должна быть привязана покупка доступа"
  elsif state == "завершен"
    @registration.workflow_state.should == "done"
    step "к регистрации должна быть привязана оплаченная покупка доступа"
  end

  if  %w(имеется, подтвержден, завершен).include? state
    @registration.phone.should          == Presets.current[:phone_confirmation]
    @registration.password.should       == Presets.current[:password]
    @registration.inn.should            == Presets.current[:inn]
    @registration.region_code.should    == Presets.current[:region_code]

    if  %w(подтвержден, завершен).include? state
      @registration.admin_notified.should == true
      @registration.user_id.should be
      @registration.contact_id            == Presets.current[:contact_id] 
      @registration.person_id             == Presets.current[:person_id]

      User.exists?(@registration.user_id).should be true
      u = User.find(@registration.user_id)
      u.api_token.should_not be_empty
      u.integration_id.should == Presets.current[:integration_id]
      u.siebel_id.should == Presets.current[:siebel_id]
      u.is_concierge.should be false
      u.is_super_concierge.should be false
      u.approved.should be false
      u.registration.should == @registration
    
      @registration.uas_user.class.should == Uas::User
      @registration.uas_user.user_id.should == Presets.current[:integration_id]
      @registration.uas_user.is_disabled.should be false
    end
  end
end

Если(/^начинает регистрацию$/) do
  VCR.use_cassette(Presets.cassette) do
    step %Q(пользователь кликает кнопку "Зарегистрироваться" в форме регистрации и входа)
    step "Ajax запрос выполняется"
    step "ждать завершения всех Ajax запросов"
  end
end

Если(/^не зарегистрированный пользователь заходит на сайт$/) do
  step %Q(неавторизованный пользователь открывает "главную страницу")
  step "имеется форма регистрации и входа"
end

Если(/^(|отмена ?)компании в Siebel не существует$/) do |negation|
  if negation == "отмена "
    Registration.any_instance.unstub(:siebel_company_exists?)
  else
    Registration.any_instance.should_receive(:siebel_company_exists?).and_return(false)
  end
end

Если(/^(|отмена ?)контакт в Siebel существует$/) do |negation|
  if negation == "отмена "
    Object.send(:remove_const, :Contact) if defined? :Contact# RAILS will define it then
  else
    Contact = Presets.current[:contact_model_stub]
  end
end

Если(/^(|отмена ?)аккаунт в Siebel существует$/) do |negation|
  if negation == "отмена "
    Object.send(:remove_const, :Account) if defined? :Account# RAILS will define it then
  else
    Account = Presets.current[:account_model_stub]
  end
end

Если(/^правильно заполняет ОГРН и телефон и переходит к следующему шагу$/) do
  step %Q(пользователь заполняет поле ввода "Введите телефон" в форме регистрации и входа значением "#{Presets.current[:phone]}")
  step %Q(пользователь заполняет поле ввода "Введите ОГРН" в форме регистрации и входа значением "#{Presets.current[:ogrn]}")
  step "начинает регистрацию"
  step "имеется объект модели регистрации"
  step "отмена компании в Siebel не существует"
end

То(/^видит правильные регистрационные данные$/) do
  within(area_to_selector("форма подтверждения регистрации")) do
    find('.js-registration_ogrn'      ).text.should eq(Presets.current[:ogrn])
    find('.js-registration_first_name').text.should eq(Presets.current[:first_name])
    find('.js-registration_last_name' ).text.should eq(Presets.current[:last_name])
    find('.js-registration_phone'     ).text.should eq(Presets.current[:phone_confirmation])
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
  VCR.use_cassette(Presets.cassette) do
    step %Q(пользователь кликает кнопку "Дальше" в форме подтверждения регистрации)
    if effect == " неудачно"
      step "Ajax запрос не выполняется"
    else
      step "Ajax запрос выполняется"
      step "ждать завершения всех Ajax запросов"
    end
  end
end

То(/^выбирает тарифный план (Квартал|Год?)$/) do |plan|
  VCR.use_cassette(Presets.cassette) do
    step %Q(пользователь кликает кнопку "Выбрать" в форме тариф #{plan})
    step "Ajax запрос выполняется"
    step "ждать завершения всех Ajax запросов 10 сек"
    step "задержка 1 сек"
    step %Q(скриншот "registration - tariff confirmation")
    step %Q(пользователь кликает кнопку "Оплатить" в форме подтверждения тарифа)
    step %Q(пользователь оказывается на "странице оплаты")
    step %Q(скриншот "registration - payment page")
  end
end

То(/^генератор паролей возвращает пароль "(.*?)"$/) do |given_password|
  allow(PasswordGenerator).to receive(:generate).and_return(given_password)
end

То(/^генератор паролей возвращает правильный пароль/) do
  step %Q(генератор паролей возвращает пароль "#{Presets.current[:password]}")
end

Если(/^проверяет свои ОГРН, телефон и имя, вводит пароль и переходит к следующему шагу$/) do
  step %Q(скриншот "registration - confirmation start")
  step "видит правильные регистрационные данные"
  step "получает смс с паролем"
  #step "проверяет работу кнопки Отправить данные еще раз"

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
  step "контакт в Siebel существует"
  step "аккаунт в Siebel существует"
  step "подтверждает регистрацию"
  step "отмена контакт в Siebel существует"
  step "отмена аккаунт в Siebel существует"
  step "подтвержден объект модели регистрации"
end

То(/^к регистрации (|не ?)должна быть привязана покупка доступа$/) do |negation|
  @ap = AccessPurchase.last
  if negation == 'не '
    @ap.should_not be
  else
    @ap.should be
    @ap.offering_id.should       == Presets.current[:offering_id]
    @ap.offering_price_id.should == Presets.current[:offering_price_id]
    @ap.user.should be
    @ap.user.registration.should == @registration
    @ap.order.should be
  end
end

То(/^к регистрации должна быть привязана (|не ?)оплаченная покупка доступа$/) do |negation|
  step "к регистрации должна быть привязана покупка доступа"
  if negation == 'не '
    @ap.order.paid?.should be false
    @ap.paid?.should be false
  else
    @ap.order.paid?.should be true
    @ap.paid?.should be true
  end
end

Если(/^платежная система подтверждает приложению выполнение платежа$/) do
  step "к регистрации должна быть привязана не оплаченная покупка доступа"
  Ds::Cart::Api.should_receive(:get_order).and_return(
    {
      "OrderStatus"=>Ds::Purchase::Order::PAID,
      "LastEditedDate"=> 5.seconds.ago.to_s, 
    }
  )
  get "/access_purchases/#{@ap.id}/processed"
  step "к регистрации должна быть привязана оплаченная покупка доступа"
end

То(/^регистрация завершена$/) do
  step "завершен объект модели регистрации"
end

То(/^пользователь имеет оплаченный доступ$/) do
  User.last.has_paid_access?.should be true
end
