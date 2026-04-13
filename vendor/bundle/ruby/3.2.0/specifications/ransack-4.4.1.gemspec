# -*- encoding: utf-8 -*-
# stub: ransack 4.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ransack".freeze
  s.version = "4.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/activerecord-hackery/ransack/blob/main/CHANGELOG.md" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ernie Miller".freeze, "Ryan Bigg".freeze, "Jon Atack".freeze, "Sean Carroll".freeze, "David Rodr\u00EDguez".freeze]
  s.date = "2025-09-29"
  s.description = "Powerful object-based searching and filtering for Active Record with advanced features like complex boolean queries, association searching, custom predicates and i18n support.".freeze
  s.email = ["ernie@erniemiller.org".freeze, "radarlistener@gmail.com".freeze, "jonnyatack@gmail.com".freeze, "magma.craters2h@icloud.com".freeze]
  s.homepage = "https://github.com/activerecord-hackery/ransack".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Object-based searching for Active Record.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 7.2"])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 7.2"])
  s.add_runtime_dependency(%q<i18n>.freeze, [">= 0"])
end
