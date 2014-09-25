module SelectorsHelpers
  def area_to_selector(name)
    case name
    when /шапк(?:а|е)/                     then 'header.page-header'
    when /контент(?:е|)/                    then 'section.page-body'
    when /подвал(?:е)/                     then 'footer.page-footer'
    when /сообщени(?:е|и|я)/               then '#myModal'
    when /форм(?:а|е) регистрации и входа/ then '.js-forms_container'
    when /форм(?:а|е) обратной связи/      then '.js-feedback_form'
    when /форм(?:а|е) подтверждения регистрации/ then '.js-confirmation_form'
    else
      raise "Unknown area: #{name}, should be either шапк(а|е), контент(е), подвал(е) или форм(а|е) регистрации и входа или форм(а|е) обратной связи"
    end
  end
end

World(SelectorsHelpers)
