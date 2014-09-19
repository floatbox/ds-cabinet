# Переходит на указанную страницу
# @param[String] authorized - неавторизованный|авторизованный
# @param[String] page - человекочитаемое название страницы, например, главная страница|страница логина
#
Если(/^(неавторизованный|авторизованный) пользователь открывает "(.*?)"$/) do |authorized, page|
  visit path_to(page)
end

# Проверяет, выполнен ли переход на указанную страницу
# @param[String] page - человекочитаемое название страницы, например, главная страница|страница логина
#
Если(/^пользователь оказ(?:ывается|ался) на "(.*?)"$/) do |page|
  current_path.should == path_to(page)
end

# Снимает скриншот и записывает в файл с указанным названием с расширением .png в папку features/screenshots
# @param[String] - название файла (без расширения) для сохранения скриншота. Файл получит расширение .png
Если(/^скриншот "(.*?)"$/) do |name|
  screenshot_take(name)
end

# Проверяет наличие или отсутствие элемента в определенной области страницы
# @param[String] area - шапка|контент|подвал
# @param[String] existence - имеется|отсутствует
# @param[String] element - кнопка|ссылка|поле ввода
# @param[String] name - текст ссылки или кнопки, или значение placeholder для поля ввода
#
То(/^в (.*?) (имеется|отсутствует?) (.*?) "(.*?)"$/) do |area, existence, element, name|
  x = find(selector_to_area area)
  
  should_exist = case existence
  when 'имеется'
    true
  when 'отсутствует'
    false
  else
    raise "Unknown option: #{existence}, should be either имеется or отсутствует"
  end

  case element
  when /кнопка/ 
    should_exist ? ( x.should have_selector     :button, name ) :
                   ( x.should_not have_selector :button, name )
  when /ссылка/
    should_exist ? ( x.should have_selector     :link, name ) : 
                   ( x.should_not have_selector :link, name )
  when /поле ввода/
    should_exist ? ( x.should have_xpath     %Q(//input[@placeholder='#{name}']) ) : 
                   ( x.should_not have_xpath %Q(//input[@placeholder='#{name}']) )
  when /переключатель/
    should_exist ? ( x.should have_selector("label.cuc-switcher_label", text:name ) ) :
                   ( x.should_not have_selector("label.cuc-switcher_label", text:name ) )
  end
end

# Кликает на кнопке или ссылке
# @param[String] element - кнопка|кнопку|кнопке|ссылка|ссылку|ссылке
# @param[String] name - текст ссылки или кнопки
# @param[String] area - шапка|контент|подвал
Если(/^пользователь кликает (.*?) "(.*?)" в (.*?)$/) do |element, name, area|
  within(selector_to_area area) do
    case element
    when "кнопку"
      click_button name
    when "ссылку"
      click_link name
    when "переключатель"
      should have_selector("label.cuc-switcher_label", text:name )
      find("label.cuc-switcher_label", text:name ).click
    else
      raise "Unknown option: #{existence}, should be either кнопку, ссылку, переключатель"
    end
  end
end
