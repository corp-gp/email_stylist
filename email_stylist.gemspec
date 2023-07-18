# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_stylist/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.0'
  spec.name          = 'email_stylist'
  spec.version       = EmailStylist::VERSION
  spec.authors       = ['ermolaev']
  spec.email         = ['andrey@ermolaev.me']

  spec.summary       = 'Email Stylist'
  spec.description   = 'GP email stylist.'
  spec.homepage      = 'https://gitlab.groupprice.ru/gp-corp/email_stylist'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'inky-rb'
  spec.add_dependency 'premailer'
end
