$ ->
  class FeedbackForm
    constructor: ->
      @form = new RemoteForm('.js-feedback_form', this)
      @default_success = @default_error = @default_before = true

    success: (event, data) =>
      Dialog.info_text([data.message])

    error: (event, data, textStatus) =>
      Dialog.show_errors_json(data.responseJSON)

  new FeedbackForm()
