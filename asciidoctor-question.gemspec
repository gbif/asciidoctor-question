# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciidoctor-question/version'

Gem::Specification.new do |s|
  s.name          = "asciidoctor-question"
  s.version       = Asciidoctor::Question::VERSION
  s.authors       = ["Marcel Hoppe"]
  s.email         = ["marcel.hoppe@mni.thm.de"]
  s.description   = %q{Asciidoctor questioning extension.rb}
  s.summary       = %q{An extension.rb for asciidoctor-question that adds support for multiple choise and gap questions}
  s.platform      = $platform
  s.homepage      = "https://github.com/hobbypunk90/asciidoctor-question"
  s.license       = "MIT"

  begin
    s.files             = `git ls-files -z -- */* {CHANGELOG,LICENSE,README,Rakefile}*`.split "\0"
  rescue
    s.files             = Dir['**/*']
  end
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 12"
  s.add_development_dependency "rspec", "~> 3.5"

  s.add_runtime_dependency "asciidoctor", "~> 1.5"
  s.add_runtime_dependency "nokogiri", "~> 1.6"
end