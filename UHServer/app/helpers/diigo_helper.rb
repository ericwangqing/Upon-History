module DiigoHelper
  def clean_html (html_text)
    require 'sanitize'
    Sanitize.clean(html_text, Sanitize::Config::RELAXED)
  end
end