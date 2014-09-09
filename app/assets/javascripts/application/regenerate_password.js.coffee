$ ->
  form = $('.js-regenerate_password_form')
  link = $('.js-regenerate_password_link')
  link_click = ()-> 
    form.submit()
  link.click -> link_click()
  form.on 'ajax:success', (event, data) ->
    Preloader.hide()
    link.click -> link_click()
    Dialog.info_text(["Пароль успешно отправлен на телефон, проверьте смс"])
  form.on 'ajax:error', (event, data, textStatus) =>
    Dialog.show_errors_json(data.responseJSON)
    Preloader.hide()
    link.click -> link_click()
  form.on 'ajax:before', (event, data) ->
    Preloader.show(link)
    link.unbind('click')
