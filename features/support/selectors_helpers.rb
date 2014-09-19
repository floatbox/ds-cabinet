module SelectorsHelpers
  def selector_to_area(name)
    case name
    when /шапк(?:а|е)/
      'header.page-header'
    when /контент(?:е)/
      'section.page-body'
    when /подвал(?:е)/
      'footer.page-footer'
    else
      raise "Unknown area: #{name}, should be either шапк(а|е), контент(е), подвал(е)"
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
