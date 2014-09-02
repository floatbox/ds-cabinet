# Панель разработчика. Идет в комплекте с: 
# * фрагментом app/views/application/_development_panel.html.erb
#
# Доступна только в окружении :development
#
# Умеет:
# * добавлять на панель ссылки, с обработчиками кликов
#

$ ->
  class window.DevelopmentPanel
    @id: (id) -> 
      if(id)
        @_id = id
      else
        @_id ||= "#development_panel"
    @show: () ->
      $(@id()).show()

  class window.DevelopmentPanel.Link
    li: () ->
      "<li><a href=\"#\" class=\"#{@class}\">#{@name}</a></li>"
    constructor: (@name, @class, @handler) ->
      $("#{DevelopmentPanel.id()} ul").append(this.li(@name, @class))
      $("#{DevelopmentPanel.id()} ul li a.#{@class}").last().click(this.click)
      DevelopmentPanel.show()
    click: () =>
      console.log("#development_panel ul li a.#{@class} clicked")
      @handler.call()
    
  test_function = () ->
    alert("Here!")

  new window.DevelopmentPanel.Link "Тестовая ссылка alert('Here!')", "alert_link", test_function

  new window.DevelopmentPanel.Link "Добавить тестовую ссылку", "add_alert_link", () ->
    new window.DevelopmentPanel.Link "Тестовая ссылка alert('Here again!')", "alert_link", test_function
