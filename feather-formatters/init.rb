gem "RedCloth"
require "redcloth"
gem "BlueCloth"
require "bluecloth"
gem 'coderay'
require 'coderay'

Hooks::Formatters.register_formatter("textile") do |text|
  RedCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("markdown") do |text|
  BlueCloth.new(text).to_html
end

Hooks::Formatters.register_formatter('coderay') do |text|
  text.scan(/(<code\:([a-z].+?)>(.+?)<\/code>)/m).each do |match|
    text.gsub!(match[0],CodeRay.scan(match[2], match[1].to_sym).div(:css => :class))
  end
  text
end