# frozen_string_literal: true

module Pacman
  module Arcade
    class PelletField
      def initialize(pellets:, powers:)
        @pellets = pellets.to_set
        @powers = powers.to_set
      end

      def eat(position)
        return :pellet if pellets.delete?(position)
        return :power if powers.delete?(position)

        nil
      end

      def empty?
        remaining.zero?
      end

      def remaining
        pellets.size + powers.size
      end

      private

      attr_reader :pellets, :powers
    end
  end
end
