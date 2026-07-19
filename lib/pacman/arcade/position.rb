# frozen_string_literal: true

module Pacman
  module Arcade
    Position = Data.define(:row, :col) do
      def step(direction)
        Position.new(row: row + direction.dy, col: col + direction.dx)
      end

      def distance_sq(other)
        ((row - other.row)**2) + ((col - other.col)**2)
      end
    end
  end
end
