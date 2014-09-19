# Кликает на владке формы регистрации и входа
# @param[String] element - кнопка|кнопку|кнопке|ссылка|ссылку|ссылке
# @param[String] name - текст ссылки или кнопки
# @param[String] area - шапка|контент|подвал
Если(/^пользователь кликает на вкладке "(Вход|Регистрация?)" формы регистрации и входа$/) do |name|
  tabs = page.find('.js-forms_container')
  tab = tabs.find('div', text: name)
  tab.click
end

# Кликает на кнопке или ссылке
# @param[String] element - кнопка|кнопку|кнопке|ссылка|ссылку|ссылке
# @param[String] name - текст ссылки или кнопки
# @param[String] area - шапка|контент|подвал
Если(/^пользователь кликает (.*?) "(.*?)" в (.*?)$/) do |element, name, area|
  within(area_to_selector area) do
    case element
    when /кнопк(?:а|у|е)/
      click_button name
    when /ссылк(?:а|у|е)/
      click_link name
    end
  end
end
