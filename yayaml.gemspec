# frozen_string_literal: true

require_relative "lib/yayaml/version"

Gem::Specification.new do |spec|
  spec.name = "yayaml"
  spec.version = Yayaml::VERSION
  spec.authors = ["Tim Uruski"]
  spec.email = ["tim@uruski.xyz"]

  spec.summary = "A tool for searching YAML files"
  spec.description = "A tool for searching the structure of YAML like i18n files"
  spec.homepage = "https://github.com/timuruski/yayaml"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/timuruski/yayaml"
  spec.metadata["changelog_uri"] = "https://github.com/timuruski/yayaml/tree/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "psych", "~> 4.0.5"
end
