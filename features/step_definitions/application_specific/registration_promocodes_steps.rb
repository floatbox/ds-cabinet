# available promo codes see here https://github.com/BusinessEnvironment/ds-cabinet/wiki/%D0%9F%D1%80%D0%BE%D0%BC%D0%BE%D0%BA%D0%BE%D0%B4%D1%8B
Если(/^выбирает тарифный план (Квартал|Год?) с промокодом "(.*?)"$/) do |plan, promocode|
  step %Q(в форме тариф #{plan} имеется поле ввода "Введите промокод")
  
  within(area_to_selector("форма тариф #{plan}")) do
    fill_in 'promocode', with: promo_code
  end

  step "выбирает тарифный план #{plan}"
end
