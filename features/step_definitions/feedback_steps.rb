То(/^в поддержку должно прийти письмо обратной связи:$/) do |table|
  # wait up to 50 * 0.1 = 5 seconds for the email
  (0...50).each do
    break if unread_emails_for('Legko_support@dasreda.ru').size != 0
    puts "waiting for email"
    sleep 0.1
  end

  # go on to check the email
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
