module SelectorsHelpers
  def area_to_selector(name)
    case name
    when /шапк(?:а|е)/                     then 'header.page-header'
    when /контент(?:е)/                    then 'section.page-body'
    when /подвал(?:е)/                     then 'footer.page-footer'
    when /форм(?:а|е) регистрации и входа/ then '.js-forms_container'
    else
      raise "Unknown area: #{name}, should be either шапк(а|е), контент(е), подвал(е) или форм(а|е) регистрации и входа"
    end
  end

  def selector_to_element(type, name)
    case type
    when /кнопк(?:а|е)/
      %Q/input[value="#{name}"]/
    when /поле ввода/
      %Q/input[name="#{name}"]/
    when /ссылк(?:а|е)/
      %Q/a[name="#{name}"]/
    else
      raise "Unknown element: #{type}, should be either кнопк(а|е), ссылк(а|е), поле ввода"
    end
  end
end

World(SelectorsHelpers)
