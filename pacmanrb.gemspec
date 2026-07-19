# frozen_string_literal: true

require_relative "lib/pacman/version"

Gem::Specification.new do |spec|
  spec.name = "pacmanrb"
  spec.version = Pacman::VERSION
  spec.summary = "A Charming terminal user interface."
  spec.authors = ["Pando"]
  spec.email = ["pandorocks@proton.me"]
  spec.files = Dir.glob("{app,config,db,exe,lib}/**/*") + %w[README.md]
  spec.bindir = "exe"
  spec.executables = ["pacmanrb"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 4.0.0"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.add_dependency "charming"
  spec.add_dependency "sqlite3", "~> 2.0"
  spec.add_dependency "activerecord", "~> 8.1"
end
