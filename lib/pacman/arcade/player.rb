# frozen_string_literal: true

module Pacman
  module Arcade
    class Player
      attr_reader :position, :direction

      def initialize(position:, direction:)
        @start = position
        @initial_direction = direction
        @position = position
        @direction = direction
      end

      def respawn
        @position = @start
        @direction = @initial_direction
        @queued_turn = nil
      end

      def queue_turn(new_direction)
        @queued_turn = new_direction
      end

      def advance(maze)
        apply_queued_turn(maze)
        ahead = maze.wrap(position.step(direction))
        @position = ahead unless maze.wall?(ahead)
      end

      private

      def apply_queued_turn(maze)
        return unless @queued_turn
        return if maze.wall?(maze.wrap(position.step(@queued_turn)))

        @direction = @queued_turn
        @queued_turn = nil
      end
    end
  end
end
