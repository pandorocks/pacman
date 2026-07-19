# frozen_string_literal: true

module Pacman
  class GameController < ApplicationController
    def show
      render :show,
        game: game,
        palette: command_palette
    end

    private

    def game
      state(:game, GameState)
    end
  end
end
