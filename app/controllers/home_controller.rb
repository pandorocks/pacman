# frozen_string_literal: true

module Pacman
  class HomeController < ApplicationController
    key "enter", :start_game, scope: :global
    key "space", :start_game, scope: :global

    def show
      render :show, home: home, palette: command_palette
    end

    def start_game
      navigate_to "/game"
    end

    private

    def home
      state(:home, HomeState)
    end
  end
end
