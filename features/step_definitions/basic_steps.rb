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
  x = find(area_to_selector area)
  should_exist = existence == 'имеется' ? true : false

  case element
  when "кнопка" 
    should_exist ? ( x.should     have_selector     :button, name ) :
                   ( x.should_not have_selector :button, name )
  when "ссылка"
    should_exist ? ( x.should     have_selector :link, name ) : 
                   ( x.should_not have_selector :link, name )
  when "поле ввода"
    should_exist ? ( x.should     have_xpath "//input[@placeholder='#{name}']" ) : 
                   ( x.should_not have_xpath "//input[@placeholder='#{name}']" )
  when "моногострочное поле ввода"
    should_exist ? ( x.should     have_xpath "//textarea[@placeholder='#{name}']" ) : 
                   ( x.should_not have_xpath "//textarea[@placeholder='#{name}']" )
  when "переключатель"
    should_exist ? ( x.should     have_selector("label.cuc-switcher_label", text:name ) ) :
                   ( x.should_not have_selector("label.cuc-switcher_label", text:name ) )
  end
end

# Кликает на кнопке или ссылке
# @param[String] element - кнопка|кнопку|кнопке|ссылка|ссылку|ссылке
# @param[String] name - текст ссылки или кнопки
# @param[String] area - шапка|контент|подвал
Если(/^пользователь кликает (кнопку|ссылку|переключатель?) "(.*?)" в (.*?)$/) do |element, name, area|
  @windows_handles = page.driver.browser.window_handles
  within(area_to_selector area) do
    case element
      when "кнопку"        then click_button name
      when "ссылку"        then click_link name
      when "переключатель" then find("label.cuc-switcher_label", text:name ).click
    end
  end
end

То(/^открывается новое окно$/) do
  @windows_handles - page.driver.browser.window_handles == -1
end

То(/^открывшееся окно имеет заголовок "(.*?)"$/) do |text|
  new_window = page.driver.browser.window_handles.last 
  page.within_window new_window do
    should have_selector('h1', text: text)
  end
end

