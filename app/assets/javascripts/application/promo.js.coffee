$ ->
  promos = []
  heights = []
  classes = ['j-signin', 'j-home']
  tops = ['115px', '70px']
  current = 0

  $('.promo').each ->
    promos.push(this)
    heights.push($(this).outerHeight() + 30)
    $(this).hide()
    $(this).css(height: 0) if promos.length > 1

  $(promos[0]).show()

  setInterval ->
    nextImageIndex = current + 1
    nextImageIndex = 0 if nextImageIndex >= promos.length
    $('.jumbotron').removeClass(classes[current]).addClass(classes[nextImageIndex])

    $('.wrap-content').animate {top:tops[nextImageIndex]}, 400, 'linear'

    $(promos[current]).animate {height: 0}, 400, 'linear', ->
      $(promos[current]).hide()
      current++
      current = 0 if current >= promos.length
      $(promos[current]).show()
      $(promos[current]).animate {height: "#{heights[current]}px"}, 400, 'linear'
  , 7000