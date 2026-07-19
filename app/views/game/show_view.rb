# frozen_string_literal: true

module Pacman
  module Game
    class ShowView < Charming::View
      def render
        game.title
      end
    end
  end
end
