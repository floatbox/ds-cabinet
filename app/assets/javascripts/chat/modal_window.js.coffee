$ ->
  $('body').on 'click', '.show-modal-window', (event, data) ->
    event.preventDefault()
    target = $($(this).data('target'))
    target.load this.href, (response, status, xhr) ->
      if status is 'success'
        target.modal()
      else
        window.location.replace('/')