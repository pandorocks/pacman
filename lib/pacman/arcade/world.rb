# frozen_string_literal: true

module Pacman
  module Arcade
    class World
      attr_reader :maze, :player, :pellets

      def initialize(maze:, player:, pellets:, scoreboard:)
        @maze = maze
        @player = player
        @pellets = pellets
        @scoreboard = scoreboard
      end

      def tick
        player.advance(maze)
        eat_at(player.position)
      end

      def queue_turn(direction)
        player.queue_turn(direction)
      end

      def score
        scoreboard.total
      end

      private

      attr_reader :scoreboard

      EATEN_EVENTS = {pellet: :pellet_eaten, power: :power_pellet}.freeze

      def eat_at(position)
        kind = pellets.eat(position)
        return [] unless kind

        scoreboard.public_send(:"#{kind}!")
        [EATEN_EVENTS.fetch(kind)]
      end
    end
  end
end
