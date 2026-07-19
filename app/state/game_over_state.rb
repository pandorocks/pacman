# frozen_string_literal: true

module Pacman
  class GameOverState < ApplicationState
    attribute :title, :string, default: "GameOver"
    attribute :score, :integer, default: 0
    attribute :level, :integer, default: 1
  end
end
