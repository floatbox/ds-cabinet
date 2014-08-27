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
    if should_exist
      begin
        x.should have_selector(:button, name)
      rescue Capybara::ElementNotFound
        x.should have_selector(:link, name) # ссылка может выглядеть как кнопка
      end
    else
      ( x.should have_not_selector :button, name ) && 
      ( x.should have_not_selector :link,   name )
    end
  when /ссылка/
    should_exist ? ( x.should have_selector     :link, name ) : 
                   ( x.should have_not_selector :link, name )
  when /поле ввода/
    should_exist ? ( x.should have_xpath    %Q(//input[@placeholder='#{name}']) ) : 
                   ( x.should have_no_xpath %Q(//input[@placeholder='#{name}']) )
  end
end

# Кликает на кнопке или ссылке
# @param[String] element - кнопка|кнопку|кнопке|ссылка|ссылку|ссылке
# @param[String] name - текст ссылки или кнопки
# @param[String] area - шапка|контент|подвал
Если(/^пользователь кликает (.*?) "(.*?)" в (.*?)$/) do |element, name, area|
  within(selector_to_area area) do
    case element
    when /кнопк(?:а|у|е)/
      begin
        click_button name
      rescue Capybara::ElementNotFound
        click_link name # возможно, это ссылка, стилизованная под кнопку
      end
    when /ссылк(?:а|у|е)/
      click_link name
    end
  end
end
