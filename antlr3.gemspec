require_relative 'lib/antlr3/version'
Gem::Specification.new do |spec|

  # Siehe antlr3.yml
  #
  spec.name = 'antlr3'
  spec.version = ANTLR3::VERSION_STRING
  spec.authors = %w[Kyle Yetter]
  spec.email = %w[kcy5b@yahoo.com]

  spec.summary = ' Fully-featured ruby parser generation for ANTLR version 3.'
  spec.description = 'xxx'
  spec.homepage = 'http://antlr.ohboyohboyohboy.org/'
  spec.license = 'BSD'

  spec.metadata['allowed_push_host'] = 'https://gemfury.com/'

  spec.files = Dir.glob('{bin,lib,java,dev-lib}/**/*')
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_development_dependency 'rspec', "~>1.1.11"
  spec.add_development_dependency 'rspec-core'
  spec.required_ruby_version =  ">= 1.8.7" # 3.2
  #spec.add_development_dependency 'test/unit??'
end