$ ->
  class window.Session
    @shakeLoginForm: ->
      $('.js-forms_container').effect('shake')
    @gotoLoginForm: ->
      form = $('.case-regin .enter')
      if form.length
        form.click()
        Session.shakeLoginForm()
      else
        window.location.replace('/')
      form.preventDefault()

  $('a.js-gotoLoginForm').click ->
    Session.gotoLoginForm()
