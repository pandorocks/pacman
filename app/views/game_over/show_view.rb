# frozen_string_literal: true

module Pacman
  module GameOver
    class ShowView < Charming::View
      def render
        game_over.title
      end
    end
  end
end
