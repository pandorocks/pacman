# frozen_string_literal: true

module Pacman
  module Game
    class ShowView < Charming::View
      def render
        return cramped_notice if cramped?

        column(
          render_component(HudComponent.new(world: world)),
          render_component(BoardComponent.new(world: world)),
          gap: 1
        )
      end

      private

      def cramped?
        screen = layout_screen
        screen.width < (world.maze.width * 2) || screen.height < (world.maze.height + 2)
      end

      def cramped_notice
        text "Terminal too small — need at least " \
          "#{world.maze.width * 2}x#{world.maze.height + 2}.", style: theme.warn
      end
    end
  end
end
