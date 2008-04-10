gem "RedCloth"
require "redcloth"
gem "BlueCloth"
require "BlueCloth"
gem "rubypants"
require "rubypants"

Hooks::Formatters.register_formatter("textile") do |text|
  RedCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("markdown") do |text|
  BlueCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("textile+smartypants") do |text|
  RubyPants.new(RedCloth.new(text).to_html).to_html
end

Hooks::Formatters.register_formatter("markdown+smartypants") do |text|
  RubyPants.new(BlueCloth.new(text).to_html).to_html
end