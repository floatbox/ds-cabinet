$ ->
  $('body').on 'click', '.js-show-modal-window', (event, data) ->
    event.preventDefault()
    targetName = $(this).data('target')
    target = $(targetName)
    target.load this.href, (response, status, xhr) ->
      if status is 'success'
        $.fancybox(targetName)
      else
        window.location.replace('/')

  $('body').on 'click', '.js-close-modal', (event) ->
    event.preventDefault()
    event.stopPropagation()
    $.fancybox.close()