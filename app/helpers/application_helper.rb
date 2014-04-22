module ApplicationHelper

  # Adds HTML markup to the plane text with paragraphs separated by new lines.
  # @param text [String] original text
  # @return [ActiveSupport::SafeBuffer] HTML safe text splitted by <p> tags
  def paragraphs(text)
    paragraphs = text.split("\n").map(&:strip).select(&:present?)
    paragraphs.map{|p| "<p>#{p}</p>"}.join("\r\n").html_safe
  end

end
