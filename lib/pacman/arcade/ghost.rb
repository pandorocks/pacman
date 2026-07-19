# frozen_string_literal: true

module Pacman
  module Arcade
    class Ghost
      attr_reader :position, :direction

      def initialize(spawn:, brain:, direction: Direction.up)
        @spawn = spawn
        @brain = brain
        @direction = direction
        @position = spawn.start
        @state = :normal
      end

      def advance(world)
        @direction = choose_direction(world)
        @position = world.maze.wrap(position.step(@direction))
        revive if eaten? && position == spawn.start
      end

      def frighten
        @state = :frightened unless eaten?
      end

      def calm
        @state = :normal unless eaten?
      end

      def devour
        @state = :eaten
      end

      def edible?
        @state == :frightened
      end

      def eaten?
        @state == :eaten
      end

      def respawn
        @position = spawn.start
        @direction = Direction.up
        @state = :normal
      end

      private

      attr_reader :spawn, :brain

      def choose_direction(world)
        if edible?
          world.navigator.wander(from: position, current: direction, rng: world.rng)
        else
          world.navigator.toward(target: target(world), from: position, current: direction)
        end
      end

      def target(world)
        return spawn.start if eaten?
        return spawn.corner if world.mode == :scatter

        brain.target(world)
      end

      def revive
        @state = :normal
      end
    end
  end
end
