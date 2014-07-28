$ ->
  $('body').on 'click', '.js-expand-messages, .js-collapse-messages', (event) ->
    event.preventDefault()
    $topic = $(this).closest('.js-topic')
    $topic.find('.js-expand-messages').toggle()
    $topic.find('.js-collapse-messages').toggle()
    $topic.find('.js-message.js-collapsable').toggle('wrap')
    false