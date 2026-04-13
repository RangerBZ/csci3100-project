# -*- encoding: utf-8 -*-
# stub: cucumber-ci-environment 11.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-ci-environment".freeze
  s.version = "11.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 3.2.8".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cucumber/ci-environment/issues", "changelog_uri" => "https://github.com/cucumber/ci-environment/blob/main/CHANGELOG.md", "source_code_uri" => "https://github.com/cucumber/ci-environment/tree/main/ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vincent Pr\u00EAtre".freeze]
  s.date = "1980-01-02"
  s.description = "Detect CI Environment from environment variables".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://github.com/cucumber/ci-environment".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "cucumber-ci-environment-11.0.0".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, ["~> 13.3"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.13"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.81.0"])
  s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.23.0"])
  s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.6.0"])
  s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 3.7.0"])
end
