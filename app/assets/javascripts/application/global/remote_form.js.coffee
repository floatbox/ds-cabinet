$ ->
  class window.RemoteForm
    disable: => 
      @button.attr('disabled', 'disabled')
      @button.fadeTo('fast', 0.5)
      Preloader.show(@button)
      
    enable: => 
      @button.removeAttr('disabled')
      @button.fadeTo('fast', 1.0)
      Preloader.hide()

    constructor: (@selector, @receiver) ->
      @form = $(@selector)
      @button = @form.find('button:submit')

      @form.on 'ajax:success', (event, data) =>
        @enable() if @receiver['default_success']
        @receiver['success'].call(self, event, data) if @receiver['success']

      @form.on 'ajax:error', (event, data, textStatus) =>
        @enable() if @receiver['default_error']
        @receiver['error'].call(self, event, data) if @receiver['error']

      @form.on 'ajax:before', (event, data) =>
        @disable() if @receiver['default_before']
        @receiver['before'].call(self, event, data) if @receiver['before']
