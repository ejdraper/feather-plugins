gem "RedCloth"
require "redcloth"
gem "BlueCloth"
require "bluecloth"
gem "rubypants"
require "rubypants"
gem 'coderay'
require 'coderay'

def sanitize_code(text)
  text.scan(/(<code\:([a-z].+?)>(.+?)<\/code>)/m).each do |match|
    text.gsub!(match[0],CodeRay.scan(match[2], match[1].to_sym).div(:css => :class))
  end
  text
end

Hooks::Formatters.register_formatter("textile") do |text|
  RedCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("markdown") do |text|
  RubyPants.new(BlueCloth.new(text).to_html).to_html
end

Hooks::Formatters.register_formatter('markdown + coderay') do |text|
  sanitize_code(BlueCloth.new(text)).to_html
end

Hooks::View.register_partial_view "head", 'coderay'