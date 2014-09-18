$ ->
  class window.Session
    @shakeForm: -> 
      $('.js-forms_container').effect('shake')
    @gotoForm: (click_selector)->
      form = $(click_selector)
      if form.length
        @scrollTo(form)
        form.click()
        Session.shakeForm()
      else
        window.location.replace('/')
    @scrollTo: (selector) ->
      body = $("html, body")
      body.animate({scrollTop:$(selector).position().top}, '500', 'swing', () -> {})

    @gotoRegistrationForm: =>
      @gotoForm('.case-regin .enter')
    @gotoLoginForm: =>
      @gotoForm('.case-regin .reg')

    @gotoHowItWorks: =>
      @scrollTo('.case-guide')
      undefined
    @gotoTariffs: =>
      @scrollTo('.case-tariff')
      undefined
    @gotoFeedback: =>
      @scrollTo('.case-callback')
      undefined

  $('a.js-gotoLoginForm').click ->
    Session.gotoLoginForm()
  $('a.js-gotoRegistrationForm').click ->
    Session.gotoRegistrationForm()

  $('a.js-gotoHowItWorks').click ->
    Session.gotoHowItWorks()
  $('a.js-gotoTariffs').click ->
    Session.gotoTariffs()
  $('a.js-gotoFeedback').click ->
    Session.gotoFeedback()
