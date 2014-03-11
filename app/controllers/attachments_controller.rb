class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.create(attachment_params)
  end

  private

    def attachment_params
      params.require(:attachment).permit!
    end
end