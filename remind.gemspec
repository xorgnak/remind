# frozen_string_literal: true

require_relative "lib/remind/version"

Gem::Specification.new do |spec|
  spec.name = "remind"
  spec.version = Remind::VERSION
  spec.authors = ["Erik Olson"]
  spec.email = ["xorgnak@gmail.com"]

  spec.summary = "gnu remind + ics files = ( :-) )"
  spec.description = "A wrapper around gnu remind leveraging ics files via url or locally."
  spec.homepage = "https://github.com/xorgnak/remind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday"
  spec.add_dependency "icalendar"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end