# frozen_string_literal: true

module Pacman
  module Arcade
    class ModeSchedule
      attr_reader :mode

      def initialize(scatter_ticks:, chase_ticks:, frightened_ticks:)
        @durations = {scatter: scatter_ticks, chase: chase_ticks}
        @frightened_ticks = frightened_ticks
        @mode = :scatter
        @remaining = scatter_ticks
        @frightened_remaining = 0
      end

      def frighten!
        @paused_mode = mode unless frightened?
        @mode = :frightened
        @frightened_remaining = @frightened_ticks
      end

      def frightened?
        mode == :frightened
      end

      def tick
        return tick_frightened if frightened?

        advance_cycle
        nil
      end

      private

      def tick_frightened
        @frightened_remaining -= 1
        return nil if @frightened_remaining.positive?

        @mode = @paused_mode
        :frightened_ended
      end

      def advance_cycle
        @remaining -= 1
        return if @remaining.positive?

        @mode = (mode == :scatter) ? :chase : :scatter
        @remaining = @durations.fetch(@mode)
      end
    end
  end
end
