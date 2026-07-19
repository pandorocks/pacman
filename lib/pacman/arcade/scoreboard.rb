# frozen_string_literal: true

module Pacman
  module Arcade
    class Scoreboard
      PELLET_POINTS = 10
      POWER_POINTS = 50
      FIRST_GHOST_BONUS = 200

      attr_reader :total

      def initialize
        @total = 0
        reset_combo
      end

      def pellet!
        award(PELLET_POINTS)
      end

      def power!
        award(POWER_POINTS)
      end

      def ghost!
        bonus = award(@next_ghost_bonus)
        @next_ghost_bonus *= 2
        bonus
      end

      def reset_combo
        @next_ghost_bonus = FIRST_GHOST_BONUS
      end

      private

      def award(points)
        @total += points
        points
      end
    end
  end
end
