# -*- encoding: utf-8 -*-
# stub: ruby_http_client 3.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby_http_client".freeze
  s.version = "3.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Elmer Thomas".freeze]
  s.date = "2025-12-16"
  s.description = "Quickly and easily access any REST or REST-like API.".freeze
  s.email = "help@twilio.com".freeze
  s.homepage = "http://github.com/sendgrid/ruby-http-client".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A simple REST client".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<codecov>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.18.5"])
end
