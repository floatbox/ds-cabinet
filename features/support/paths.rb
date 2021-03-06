module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /главн(?:ая|ой|ую) страниц(?:а|у|е)/
       '/'
    when /страниц(?:а|у|е) логина/
       '/sessions/new'
    when /страниц(?:а|у|е) оплаты/
       '/payment/merchants/dasreda/payment_ru.html'
    end
  end
end

World(NavigationHelpers)
