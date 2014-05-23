$ ->
  promos = []
  current = 0

  $('.promo').each ->
    promos.push(this)
    $(this).hide()

  $(promos[0]).show()

  setInterval ->
    $(promos[current]).hide()
    current++
    current = 0 if current >= promos.length
    $(promos[current]).show()
  , 7000