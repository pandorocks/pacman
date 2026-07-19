# frozen_string_literal: true

module Pacman
  module Arcade
    # Where a ghost lives: its starting cell and the corner it retreats to in scatter mode.
    Spawn = Data.define(:start, :corner)
  end
end
