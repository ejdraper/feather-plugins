gem "RedCloth"
require "redcloth"
gem "BlueCloth"
require "bluecloth"

Hooks::Formatters.register_formatter("textile") do |text|
  RedCloth.new(text).to_html
end

Hooks::Formatters.register_formatter("markdown") do |text|
  BlueCloth.new(text).to_html
end