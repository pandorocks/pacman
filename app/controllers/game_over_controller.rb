# frozen_string_literal: true

module Pacman
  class GameOverController < ApplicationController
    def show
      render :show,
        game_over: game_over,
        palette: command_palette
    end

    private

    def game_over
      state(:game_over, GameOverState)
    end
  end
end
