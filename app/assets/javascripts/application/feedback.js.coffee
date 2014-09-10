$ ->
  form = $('.js-feedback_form')
  form.on 'ajax:success', (event, data) ->
    form.find('button').removeAttr('disabled')
    Preloader.hide()
    Dialog.info_text([data.message])
  form.on 'ajax:error', (event, data, textStatus) =>
    form.find('button').removeAttr('disabled')
    Preloader.hide()
    Dialog.show_errors_json(data.responseJSON)
  form.on 'ajax:before', (event, data) ->
    Preloader.show(form.find('button'))
    form.find('button').attr('disabled', 'disabled')
