# frozen_string_literal: true

module Pacman
  # How much the board is zoomed for a given terminal, and how that zoom slows
  # the game's movement pace so on-screen speed stays roughly constant.
  class BoardScale
    HUD_ROWS = 2

    def initialize(screen:, maze:)
      @screen = screen
      @maze = maze
    end

    def factor
      [width_factor, height_factor].min
    end

    def cramped?
      factor < 1
    end

    SLOWDOWN_ZOOM = 3

    # Timer pulses per movement tick: full speed at modest zooms, one gentle
    # halving once cells get big enough that motion would blur across the board.
    def pace
      (factor >= SLOWDOWN_ZOOM) ? 2 : 1
    end

    private

    attr_reader :screen, :maze

    def width_factor
      screen.width / (maze.width * 2)
    end

    def height_factor
      (screen.height - HUD_ROWS) / maze.height
    end
  end
end
