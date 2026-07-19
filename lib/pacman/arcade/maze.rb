# frozen_string_literal: true

module Pacman
  module Arcade
    class Maze
      attr_reader :width, :height

      def initialize(layout)
        @rows = pad_rows(layout.lines.map(&:chomp))
        @height = @rows.length
        @width = @rows.first.length
      end

      def pellet_positions
        positions_of(".")
      end

      def power_positions
        positions_of("o")
      end

      def open_neighbors(position)
        Direction.all.map { |direction| wrap(position.step(direction)) }
          .reject { |neighbor| wall?(neighbor) }
      end

      def player_start
        positions_of("P").first
      end

      def ghost_starts
        positions_of("G")
      end

      def wrap(position)
        Position.new(row: position.row % height, col: position.col % width)
      end

      def wall?(position)
        cell(position) == "#"
      end

      private

      def cell(position)
        rows[position.row][position.col]
      end

      def positions_of(marker)
        each_position.select { |position| cell(position) == marker }
      end

      def each_position
        (0...height).to_a.product((0...width).to_a).map do |row, col|
          Position.new(row: row, col: col)
        end
      end

      attr_reader :rows

      def pad_rows(lines)
        widest = lines.map(&:length).max
        lines.map { |line| line.ljust(widest) }
      end
    end
  end
end
