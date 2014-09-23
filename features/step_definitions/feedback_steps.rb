То(/^в поддержку должно прийти письмо обратной связи (с адресом|с телефоном|от имени|с текстом?) "(.*?)"$/) do |key, val|
  sleep 0.1
  unread_emails_for('Legko_support@dasreda.ru').select do |m| 
    m.subject.should == "Сообщение через форму обратной связи"
    case key
      when 'с адресом'   then m.from.first.should == val
      when 'с телефоном' then m.body.to_s.should include("Телефон: #{val}")
      when 'от имени'    then m.body.to_s.should include("Имя: #{val}")
      when 'с текстом'   then m.body.to_s.should include(val)
    end
  end.size.should == 1
end
