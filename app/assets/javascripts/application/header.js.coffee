$ ->
  class window.Session
    @shakeForm: -> 
      $('.js-forms_container').effect('shake')
    @gotoForm: (click_selector)->
      form = $(click_selector)
      if form.length
        form.click()
        Session.shakeForm()
      else
        window.location.replace('/')
    @gotoRegistrationForm: =>
      @gotoForm('.case-regin .enter')
    @gotoLoginForm: =>
      @gotoForm('.case-regin .reg')

  $('a.js-gotoLoginForm').click ->
    Session.gotoLoginForm()
  $('a.js-gotoRegistrationForm').click ->
    Session.gotoRegistrationForm()
