# frozen_string_literal: true

module Pacman
  module Game
    class ShowView < Charming::View
      HUD_ROWS = 2

      def render
        return cramped_notice if cramped?

        Charming::UI.center(
          column(
            render_component(HudComponent.new(world: world)),
            render_component(BoardComponent.new(world: world, scale: board_scale)),
            gap: 1
          ),
          width: layout_screen.width,
          height: layout_screen.height
        )
      end

      private

      def board_scale
        [width_scale, height_scale].min
      end

      def width_scale
        layout_screen.width / (world.maze.width * 2)
      end

      def height_scale
        (layout_screen.height - HUD_ROWS) / world.maze.height
      end

      def cramped?
        board_scale < 1
      end

      def cramped_notice
        text "Terminal too small — need at least " \
          "#{world.maze.width * 2}x#{world.maze.height + HUD_ROWS}.", style: theme.warn
      end
    end
  end
end
