# frozen_string_literal: true

module Pacman
  module Game
    class ShowView < Charming::View
      def render
        column(
          render_component(HudComponent.new(world: world)),
          render_component(BoardComponent.new(world: world)),
          gap: 1
        )
      end
    end
  end
end
