# frozen_string_literal: true

require "charming"
require "zeitwerk"
require_relative "../config/database"


module Pacman
end

loader = Zeitwerk::Loader.new
loader.tag = "pacman"
loader.inflector.inflect("version" => "VERSION")
loader.push_dir(File.expand_path("pacman", __dir__), namespace: Pacman)
loader.push_dir(File.expand_path("../app/models", __dir__), namespace: Pacman)
loader.push_dir(File.expand_path("../app/state", __dir__), namespace: Pacman)
loader.push_dir(File.expand_path("../app/components", __dir__), namespace: Pacman)
loader.push_dir(File.expand_path("../app/views", __dir__), namespace: Pacman)
loader.push_dir(File.expand_path("../app/controllers", __dir__), namespace: Pacman)
loader.setup

require_relative "../config/routes"
