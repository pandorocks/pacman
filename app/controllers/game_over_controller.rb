# frozen_string_literal: true

module Pacman
  class GameOverController < ApplicationController
    key "r", :restart, scope: :global
    key "enter", :restart, scope: :global

    def show
      render :show,
        game_over: game_over,
        high_scores: HighScore.top(5).to_a,
        palette: command_palette
    end

    def restart
      state(:game, GameState).world = nil
      navigate_to "/game"
    end

    private

    def game_over
      state(:game_over, GameOverState)
    end
  end
end
