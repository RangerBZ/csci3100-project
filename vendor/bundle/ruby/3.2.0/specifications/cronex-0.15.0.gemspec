# -*- encoding: utf-8 -*-
# stub: cronex 0.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cronex".freeze
  s.version = "0.15.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Adrian Kazaku".freeze]
  s.date = "2024-10-20"
  s.description = "Ruby library that converts cron expressions into human readable strings".freeze
  s.email = ["alpinweis@gmail.com".freeze]
  s.homepage = "https://github.com/alpinweis/cronex".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Ruby library that converts cron expressions into human readable strings".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<tzinfo>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<unicode>.freeze, [">= 0.4.4.5"])
  s.add_development_dependency(%q<pry>.freeze, ["~> 0.10"])
  s.add_development_dependency(%q<rake>.freeze, [">= 12.3.3"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1"])
end
