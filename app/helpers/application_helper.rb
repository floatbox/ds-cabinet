module ApplicationHelper

  # Adds HTML markup to the plane text with paragraphs separated by new lines.
  # @param text [String] original text
  # @return [ActiveSupport::SafeBuffer] HTML safe text splitted by <p> tags
  def paragraphs(text)
    paragraphs = text.split("\n").map(&:strip).select(&:present?)
    paragraphs.map { |p|
      p = p.split(' ').map{ |w| w.scan(/.{1,80}/).join(' ') }.join(' ')
      "<p>#{p}</p>"}.join("\r\n").html_safe
  end

  def phone_input f
    f.input_field :phone, as: :string, placeholder: 'Введите телефон', class: :phone
  end

  def ogrn_input f
    f.input_field :ogrn, as: :string, placeholder: 'Введите ОГРН', class: :ogrn
  end

  def promocode_input f
    if f
      f.input_field :promo_code, as: :string, placeholder: 'Введите промокод', class: 'string'
    else
      text_field_tag :promo_code, '', placeholder: 'Введите промокод', class: 'string'
    end
  end
end
