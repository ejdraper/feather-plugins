Gem::Specification.new do |s|
  s.name = %q{coderay}
  s.version = "0.7.4.215"

  s.specification_version = 1 if s.respond_to? :specification_version=
  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["murphy"]
  s.autorequire = %q{coderay}
  s.cert_chain = nil
  s.date = %q{2006-10-19}
  s.description = %q{CodeRay is a Ruby library for syntax highlighting. I try to make CodeRay easy to use and intuitive, but at the same time fully featured, complete, fast and efficient.  Usage is simple: require 'coderay' code = 'some %q(weird (Ruby) can't shock) me!' puts CodeRay.scan(code, :ruby).html}
  s.email = %q{murphy@cYcnus.de}
  s.executables = ["coderay", "coderay_stylesheet"]
  s.extra_rdoc_files = ["./README", "./FOLDERS"]
  s.files = ["./lib/coderay.rb", "./lib/coderay/duo.rb", "./lib/coderay/encoder.rb", "./lib/coderay/scanner.rb", "./lib/coderay/style.rb", "./lib/coderay/tokens.rb", "./lib/coderay/encoders/_map.rb", "./lib/coderay/encoders/count.rb", "./lib/coderay/encoders/debug.rb", "./lib/coderay/encoders/div.rb", "./lib/coderay/encoders/html.rb", "./lib/coderay/encoders/null.rb", "./lib/coderay/encoders/page.rb", "./lib/coderay/encoders/span.rb", "./lib/coderay/encoders/statistic.rb", "./lib/coderay/encoders/text.rb", "./lib/coderay/encoders/tokens.rb", "./lib/coderay/encoders/xml.rb", "./lib/coderay/encoders/yaml.rb", "./lib/coderay/encoders/html/classes.rb", "./lib/coderay/encoders/html/css.rb", "./lib/coderay/encoders/html/numerization.rb", "./lib/coderay/encoders/html/output.rb", "./lib/coderay/helpers/file_type.rb", "./lib/coderay/helpers/gzip_simple.rb", "./lib/coderay/helpers/plugin.rb", "./lib/coderay/helpers/word_list.rb", "./lib/coderay/scanners/_map.rb", "./lib/coderay/scanners/c.rb", "./lib/coderay/scanners/debug.rb", "./lib/coderay/scanners/delphi.rb", "./lib/coderay/scanners/html.rb", "./lib/coderay/scanners/nitro_xhtml.rb", "./lib/coderay/scanners/plaintext.rb", "./lib/coderay/scanners/rhtml.rb", "./lib/coderay/scanners/ruby.rb", "./lib/coderay/scanners/xml.rb", "./lib/coderay/scanners/ruby/patterns.rb", "./lib/coderay/styles/_map.rb", "./lib/coderay/styles/cycnus.rb", "./lib/coderay/styles/murphy.rb", "./README", "./LICENSE", "./FOLDERS", "bin/coderay", "bin/coderay_stylesheet"]
  s.has_rdoc = true
  s.homepage = %q{http://coderay.rubychan.de}
  s.rdoc_options = ["-SNw2", "-mREADME", "-a", "-t CodeRay Documentation"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.requirements = ["strscan"]
  s.rubyforge_project = %q{coderay}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{CodeRay is a fast syntax highlighter engine for many languages.}
end
