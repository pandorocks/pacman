# frozen_string_literal: true

module Pacman
  class GameState < ApplicationState
    attribute :title, :string, default: "Game"
  end
end
