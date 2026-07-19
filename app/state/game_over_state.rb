# frozen_string_literal: true

module Pacman
  class GameOverState < ApplicationState
    attribute :title, :string, default: "GameOver"
  end
end
