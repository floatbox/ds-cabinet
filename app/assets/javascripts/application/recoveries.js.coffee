$ ->
  $("#recovery_phone").mask('+7 (999) 999-99-99')

  $('body').on 'ajax:before', '#recovery_regenerate_sms_verification_code', (event, data) ->
    $(this).fadeTo('fast', 0.5)

  $('body').on 'ajax:success', '#recovery_regenerate_sms_verification_code', (event, data) ->
    $(this).fadeTo('fast', 1.0)
    alert('Код подтверждения был повторно отправлен на ваш номер.')

  $('body').on 'ajax:error', '#recovery_regenerate_sms_verification_code', (event, data) ->
    $(this).fadeTo('fast', 1.0)
    alert('Извините, не удалось отправить код подтверждения. Попробуйте повторить попытку позднее.')