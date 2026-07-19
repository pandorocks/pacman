# frozen_string_literal: true

module Pacman
  module Game
    class ShowView < Charming::View
      def render
        return cramped_notice if board_scale.cramped?

        Charming::UI.center(
          column(
            render_component(HudComponent.new(world: world)),
            render_component(BoardComponent.new(world: world, scale: board_scale.factor)),
            gap: 1
          ),
          width: layout_screen.width,
          height: layout_screen.height
        )
      end

      private

      def board_scale
        @board_scale ||= BoardScale.new(screen: layout_screen, maze: world.maze)
      end

      def cramped_notice
        text "Terminal too small — need at least " \
          "#{world.maze.width * 2}x#{world.maze.height + BoardScale::HUD_ROWS}.", style: theme.warn
      end
    end
  end
end
