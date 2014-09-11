$ ->
  form = $('.js-feedback_form')
  button = form.find('button')
  form.on 'ajax:success', (event, data) ->
    button.removeAttr('disabled')
    button.fadeTo('fast', 1.0)
    Preloader.hide()
    Dialog.info_text([data.message])
  form.on 'ajax:error', (event, data, textStatus) =>
    button.removeAttr('disabled')
    button.fadeTo('fast', 1.0)
    Preloader.hide()
    Dialog.show_errors_json(data.responseJSON)
  form.on 'ajax:before', (event, data) ->
    button.attr('disabled', 'disabled')
    button.fadeTo('fast', 0.5)
    Preloader.show(button)
