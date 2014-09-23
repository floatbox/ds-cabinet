То(/^в поддержку должно прийти письмо обратной связи:$/) do |table|
  sleep 0.1
  unread_emails_for('Legko_support@dasreda.ru').select do |m| 
    table.raw.each do |key, val|
      case key
        when 'с адресом'   then m.from.first.should == val
        when 'с телефоном' then m.body.to_s.should include("Телефон: #{val}")
        when 'от имени'    then m.body.to_s.should include("Имя: #{val}")
        when 'с текстом'   then m.body.to_s.should include(val)
        when 'с темой'     then m.subject.should == val
        else raise "Bad key: #{key.inspect}"
      end
    end
  end.size.should == 1
end
