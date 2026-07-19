# frozen_string_literal: true

module Pacman
  # Draws the maze as a grid of blocks. Each maze cell becomes `scale` terminal
  # rows by `scale * 2` columns, so the board can grow to fill large terminals.
  class BoardComponent < Charming::Component
    WALL_STYLE = Charming::UI.style.foreground("#2121de")
    PELLET_STYLE = Charming::UI.style.foreground("#ffb8ae")
    CHERRY_STYLE = Charming::UI.style.foreground("#ff2121").bold
    STEM_STYLE = Charming::UI.style.foreground("#21c821")
    PLAYER_STYLE = Charming::UI.style.foreground("#ffff00").bold
    FRIGHTENED_STYLE = Charming::UI.style.foreground("#2121de").bold
    EATEN_STYLE = Charming::UI.style.foreground("#ffffff")
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
      return ghost_cell(position, subrow) if ghost_at(position)
      return PLAYER_STYLE.render(player_sprite[subrow]) if world.player.position == position
      return WALL_STYLE.render("#" * cell_width) if maze.wall?(position)
      return cherry_cell(subrow) if world.pellets.power?(position)
      return pellet_cell(position, subrow) if middle?(subrow)

      blank
    end

    def player_sprite
      @player_sprite ||= Sprites.player(scale: scale, direction: world.player.direction)
    end

    def pellet_cell(position, _subrow)
      return PELLET_STYLE.render(".".center(cell_width)) if world.pellets.include?(position)

      blank
    end

    def cherry_cell(subrow)
      Sprites.cherry(scale: scale)[subrow].chars.map { |char| cherry_char(char) }.join
    end

    def cherry_char(char)
      return char if char == " "
      return STEM_STYLE.render(char) if char == "│"

      CHERRY_STYLE.render(char)
    end

    def middle?(subrow)
      subrow == (scale - 1) / 2
    end

    def blank
      " " * cell_width
    end

    def ghost_cell(position, subrow)
      ghost = ghost_at(position)
      return FRIGHTENED_STYLE.render(Sprites.frightened(scale: scale)[subrow]) if ghost.edible?
      return EATEN_STYLE.render(Sprites.eaten(scale: scale)[subrow]) if ghost.eaten?

      ghost_style(ghost).render(Sprites.ghost(scale: scale)[subrow])
    end

    def ghost_at(position)
      world.ghosts.find { |ghost| ghost.position == position }
    end

    def ghost_style(ghost)
      GHOST_STYLES.fetch(world.ghosts.index(ghost) % GHOST_STYLES.length)
    end
  end
end
