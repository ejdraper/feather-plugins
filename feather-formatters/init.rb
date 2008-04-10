gem "RedCloth"
require "redcloth"
gem "BlueCloth"
require "bluecloth"
gem "rubypants"
require "rubypants"

Hooks::Formatters.register_formatter("textile") do |text|
  RedCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("markdown") do |text|
  BlueCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("textile+smartypants") do |text|
  RedCloth.new(RubyPants.new(text).to_html).to_html
end

Hooks::Formatters.register_formatter("markdown+smartypants") do |text|
  BlueCloth.new(RubyPants.new(text).to_html).to_html
end