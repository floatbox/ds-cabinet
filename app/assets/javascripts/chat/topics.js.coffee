$ ->
  $('body').on 'click', '.expand_messages, .collapse_messages', (event) ->
    event.preventDefault()
    $topic = $(this).closest('.row')
    $topic.find('.expand_messages').toggle()
    $topic.find('.collapse_messages').toggle()
    $topic.find('.comment-item.collapsable').toggle('wrap')
    false