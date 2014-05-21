module SearchHelper

  def highlighted(text, query)
    text.mb_chars.downcase.to_s.gsub(query.mb_chars.downcase.to_s, "<span class=\"highlighted\">#{query}</span>").html_safe
  end

end
