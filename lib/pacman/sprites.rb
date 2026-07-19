# frozen_string_literal: true

module Pacman
  # Procedurally drawn actor sprites. A board cell is `scale` character rows by
  # `scale * 2` columns; half-block characters double the vertical resolution,
  # giving a square 2k x 2k pixel grid to draw circles and skirts on.
  class Sprites
    MOUTH_COSINE = 0.75

    def self.player(scale:, direction:)
      return ["██"] if scale == 1

      sprite = new(scale)
      sprite.draw { |y, x| sprite.pacman?(y, x, direction) }
    end

    def self.ghost(scale:)
      return ["██"] if scale == 1

      sprite = new(scale)
      sprite.draw { |y, x| sprite.ghost_body?(y, x) && !sprite.eye?(y, x) }
    end

    def self.frightened(scale:)
      return ["▒▒"] if scale == 1

      sprite = new(scale)
      sprite.draw(texture: "▒") { |y, x| sprite.ghost_body?(y, x) && !sprite.eye?(y, x) }
    end

    def self.eaten(scale:)
      return ["▀▀"] if scale == 1

      sprite = new(scale)
      sprite.draw { |y, x| sprite.eye?(y, x) }
    end

    def initialize(scale)
      @scale = scale
      @pixels = scale * 2
      @center = (@pixels - 1) / 2.0
      @radius = scale - 0.15
    end

    def draw(texture: nil)
      (0...scale).map do |row|
        (0...pixels).map do |col|
          cell_char(yield(row * 2, col), yield(row * 2 + 1, col), texture)
        end.join
      end
    end

    def pacman?(y, x, direction)
      circle?(y, x) && !mouth?(y, x, direction)
    end

    def ghost_body?(y, x)
      return skirt?(x) && (x - center).abs <= radius if y == pixels - 1
      return circle?(y, x) if y < scale

      (x - center).abs <= radius
    end

    def eye?(y, x)
      return false if scale < 2

      size = [scale / 2, 1].max
      row = (pixels * 0.35).floor
      return false unless (row...(row + size)).cover?(y)

      left = (pixels * 0.3).floor
      right = (pixels * 0.65).floor
      (left...(left + size)).cover?(x) || (right...(right + size)).cover?(x)
    end

    private

    attr_reader :scale, :pixels, :center, :radius

    def cell_char(top, bottom, texture)
      return texture_char(top, bottom, texture) if texture
      return "█" if top && bottom
      return "▀" if top
      return "▄" if bottom

      " "
    end

    def texture_char(top, bottom, texture)
      (top || bottom) ? texture : " "
    end

    def circle?(y, x)
      ((y - center)**2) + ((x - center)**2) <= radius**2
    end

    def mouth?(y, x, direction)
      vy = y - center
      vx = x - center
      length = Math.sqrt((vy**2) + (vx**2))
      return false if length < radius * 0.15

      ((vy * direction.dy) + (vx * direction.dx)) / length > MOUTH_COSINE
    end

    def skirt?(x)
      ((x * 4) / pixels).even?
    end
  end
end
