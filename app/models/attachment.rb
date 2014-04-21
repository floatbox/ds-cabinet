require 'file_size_validator'

class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :messages
  mount_uploader :attachment, AttachmentUploader
  validates :attachment,
    presence: true,
    file_size: { maximum: 10.megabytes.to_i }

  # return [String] error messages that could be displayed in alert box
  def errors_as_text
    errors.messages.map do |attribute, messages|
      attribute_name = I18n.t("activerecord.attributes.#{self.class.name.to_s.singularize.underscore}.#{attribute}")
      "#{attribute_name} #{messages.join(', ')}."
    end.join(' ')
  end

end
