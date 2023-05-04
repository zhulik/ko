# frozen_string_literal: true

require_relative "lib/ko/version"

Gem::Specification.new do |spec|
  spec.name = "ko"
  spec.version = KO::VERSION
  spec.authors = ["Gleb Sinyavskiy"]
  spec.email = ["zhulik.gleb@gmail.com"]

  spec.summary = "KO"
  spec.description = "KO"
  spec.homepage = "https://github.com/zhulik/ko"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["lib/**/*.rb"] +
               Dir["exe/**/*"] +
               Dir["Cargo*"] +
               Dir["src/**/*.rs"] +
               [
                 "ext/Rakefile",
                 "ko.gemspec",
                 "Rakefile"
               ]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "src", "exe"]

  spec.extensions << "ext/Rakefile"

  spec.add_dependency "binding_of_caller", "~> 1.0.0"
  spec.add_dependency "dry-types", "~> 1.7.0"
  spec.add_dependency "memery", "~> 1.4"
  spec.add_dependency "rutie", "~> 0.0.4"
  spec.add_dependency "zeitwerk", "~> 2.6.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
