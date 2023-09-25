Gem::Specification.new do |spec|
  spec.name = 'antlr3'
  spec.version = '1.10.1'
  spec.authors = %w[Alexander Schuppisser, Christian Mühlethaler]
  spec.email = %w[alexander.schuppisser@optor.ch, christian.muehlethaler@optor.ch]

  spec.summary = 'antlr3 Bindig'
  spec.description = 'xxx'
  spec.homepage = 'https://www.planik.ch'
  spec.license = 'Nonstandard'

  spec.metadata['allowed_push_host'] = 'https://gemfury.com/'

  spec.files = Dir.glob('{bin,lib}/**/*')
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
