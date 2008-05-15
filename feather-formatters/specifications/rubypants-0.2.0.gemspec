Gem::Specification.new do |s|
  s.name = %q{rubypants}
  s.version = "0.2.0"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.cert_chain = nil
  s.date = %q{2004-11-15}
  s.description = %q{RubyPants is a Ruby port of the smart-quotes library SmartyPants.  The original "SmartyPants" is a free web publishing plug-in for Movable Type, Blosxom, and BBEdit that easily translates plain ASCII punctuation characters into "smart" typographic punctuation HTML entities.}
  s.email = %q{chneukirchen@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["install.rb", "rubypants.rb", "test_rubypants.rb", "README", "Rakefile"]
  s.homepage = %q{http://www.kronavita.de/chris/blog/projects/rubypants.html}
  s.rdoc_options = ["--main", "README", "--line-numbers", "--inline-source", "--all", "--exclude", "test_rubypants.rb"]
  s.require_paths = ["."]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{RubyPants is a Ruby port of the smart-quotes library SmartyPants.}
  s.test_files = ["test_rubypants.rb"]
end
