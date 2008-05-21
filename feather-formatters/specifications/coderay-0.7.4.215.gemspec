Gem::Specification.new do |s|
  # Basic Information
  s.name = s.rubyforge_project = 'coderay'
  s.version = '0'

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.2'
  s.requirements = ['strscan']
  s.date = Time.now.strftime '%Y-%m-%d'
  s.has_rdoc = true
  s.rdoc_options = '-SNw2', '-mREADME', '-a', '-t CodeRay Documentation'
  s.extra_rdoc_files = EXTRA_FILES.in('./')

  # Description
  s.summary = <<-EOF
CodeRay is a fast syntax highlighter engine for many languages.
  EOF
  s.description = <<-EOF
CodeRay is a Ruby library for syntax highlighting.
I try to make CodeRay easy to use and intuitive, but at the same time
fully featured, complete, fast and efficient.

Usage is simple:
  require 'coderay'
  code = 'some %q(weird (Ruby) can\'t shock) me!'
  puts CodeRay.scan(code, :ruby).html
  EOF

  # Files
  s.require_path = 'lib'
  s.autorequire = 'coderay'
  s.executables = [ 'coderay', 'coderay_stylesheet' ]

  s.files = nil  # defined later

  # Credits
  s.author = 'murphy'
  s.email = 'murphy@cYcnus.de'
  s.homepage = 'http://coderay.rubychan.de'
end
