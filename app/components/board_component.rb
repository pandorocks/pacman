# frozen_string_literal: true

module Pacman
  class BoardComponent < Charming::Component
    WALL_STYLE = Charming::UI.style.foreground("#2121de")
    PELLET_STYLE = Charming::UI.style.foreground("#ffb8ae")
    POWER_STYLE = Charming::UI.style.foreground("#ffb8ae").bold
    PLAYER_STYLE = Charming::UI.style.foreground("#ffff00").bold

    def render
      (0...maze.height).map { |row| render_row(row) }.join("\n")
    end

    private

    def maze
      world.maze
    end

    def render_row(row)
      (0...maze.width).map { |col| glyph(Arcade::Position.new(row: row, col: col)) }.join
    end

    def glyph(position)
      return PLAYER_STYLE.render("C ") if world.player.position == position
      return WALL_STYLE.render("##") if maze.wall?(position)
      return POWER_STYLE.render("o ") if world.pellets.power?(position)
      return PELLET_STYLE.render(". ") if world.pellets.include?(position)

      "  "
    end
  end
end
