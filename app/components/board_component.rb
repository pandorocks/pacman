# frozen_string_literal: true

module Pacman
  # Draws the maze as a grid of blocks. Each maze cell becomes `scale` terminal
  # rows by `scale * 2` columns, so the board can grow to fill large terminals.
  class BoardComponent < Charming::Component
    WALL_STYLE = Charming::UI.style.foreground("#2121de")
    PELLET_STYLE = Charming::UI.style.foreground("#ffb8ae")
    POWER_STYLE = Charming::UI.style.foreground("#ffb8ae").bold
    PLAYER_STYLE = Charming::UI.style.foreground("#ffff00").bold
    FRIGHTENED_STYLE = Charming::UI.style.foreground("#2121de").bold
    GHOST_STYLES = [
      Charming::UI.style.foreground("#ff0000").bold,
      Charming::UI.style.foreground("#ffb8de").bold,
      Charming::UI.style.foreground("#00ffde").bold,
      Charming::UI.style.foreground("#ffb847").bold
    ].freeze

    def render
      (0...maze.height).flat_map { |row| block_rows(row) }.join("\n")
    end

    private

    def maze
      world.maze
    end

    def scale
      assigns.fetch(:scale, 1)
    end

    def cell_width
      scale * 2
    end

    def block_rows(row)
      (0...scale).map do |subrow|
        (0...maze.width).map { |col| cell(Arcade::Position.new(row: row, col: col), subrow) }.join
      end
    end

    def cell(position, subrow)
      return ghost_cell(position) if ghost_at(position)
      return PLAYER_STYLE.render(sprite("C")) if world.player.position == position
      return WALL_STYLE.render("#" * cell_width) if maze.wall?(position)
      return pellet_cell(position, subrow) if middle?(subrow)

      blank
    end

    def pellet_cell(position, subrow)
      return POWER_STYLE.render(("o" * scale).center(cell_width)) if world.pellets.power?(position)
      return PELLET_STYLE.render(".".center(cell_width)) if world.pellets.include?(position)

      blank
    end

    def middle?(subrow)
      subrow == (scale - 1) / 2
    end

    def blank
      " " * cell_width
    end

    def sprite(char)
      (char * scale).center(cell_width)
    end

    def ghost_cell(position)
      ghost = ghost_at(position)
      return FRIGHTENED_STYLE.render(sprite("m")) if ghost.edible?
      return sprite("~") if ghost.eaten?

      ghost_style(ghost).render(sprite("M"))
    end

    def ghost_at(position)
      world.ghosts.find { |ghost| ghost.position == position }
    end

    def ghost_style(ghost)
      GHOST_STYLES.fetch(world.ghosts.index(ghost) % GHOST_STYLES.length)
    end
  end
end
