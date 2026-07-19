# frozen_string_literal: true

module Pacman
  module Arcade
    class Navigator
      def initialize(maze)
        @maze = maze
      end

      def toward(target:, from:, current:)
        candidates(from, current).min_by do |choice|
          maze.wrap(from.step(choice)).distance_sq(target)
        end
      end

      def wander(from:, current:, rng:)
        options = candidates(from, current)
        options[rng.rand(options.length)]
      end

      private

      attr_reader :maze

      def candidates(from, current)
        open = open_directions(from)
        forward = open - [current.opposite]
        forward.empty? ? open : forward
      end

      def open_directions(from)
        Direction.all.reject { |choice| maze.wall?(maze.wrap(from.step(choice))) }
      end
    end
  end
end
