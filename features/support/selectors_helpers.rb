module SelectorsHelpers
  def selector_to_area(name)
    case name
    when /шапк(?:а|е)/
       '.header'
    when /контент(?:е)/
       '.jumbotron'
    when /подвал(?:е)/
       '.footer'
    end
  end

  def selector_to_element(type, name)
    case name
    when /кнопк(?:а|е)/
       %Q/input[value="#{name}"]/
    when /поле ввода/
       %Q/input[name="#{name}"]/
    when /ссылк(?:а|е)/
       %Q/a[name="#{name}"]/
    end
  end
end

World(SelectorsHelpers)
