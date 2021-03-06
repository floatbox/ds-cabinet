$ ->
  promos = []
  heights = []
  positions = ['-1920px', '0px']
  tops = ['115px', '70px']
  current = 0

  $('.promo').each ->
    promos.push(this)
    heights.push($(this).outerHeight() + 30)
    $(this).hide()
    $(this).css(height: 0) if promos.length > 1

  $(promos[0]).addClass('current').show()

  setInterval ->
    return if $(promos[current]).hasClass('disabled')
    nextImageIndex = current + 1
    nextImageIndex = 0 if nextImageIndex >= promos.length
    $('.jumbotron').animate { 'background-position':positions[nextImageIndex] }, 1000

    $('.wrap-content').animate {top:tops[nextImageIndex]}, 1000, 'linear'

    $(promos[current]).animate {height: 0}, 500, 'linear', ->
      $(promos[current]).removeClass('current').hide()
      current++
      current = 0 if current >= promos.length
      $(promos[current]).addClass('current').show()
      $(promos[current]).animate {height: "#{heights[current]}px"}, 500, 'linear'
  , 7000