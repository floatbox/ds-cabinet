module MiscHelpers
  # e.g. 
  # wait_up_to 5.seconds do
  #   puts "waiting for email"
  #   unread_emails_for('Legko_support@dasreda.ru').size != 0
  # end
  def wait_up_to seconds, delay = 0.1, &block
    max = seconds/delay
    # wait up to 50 * 0.1 = 5 seconds for the email
    (0...max).each do |i|
      break if yield(i, max)
      sleep delay
    end
  end
end

World(MiscHelpers)
