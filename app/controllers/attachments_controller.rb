class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.create(attachment_params)
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @result = @attachment.destroy
  end

  private

    def attachment_params
      params.require(:attachment).permit!
    end
end
