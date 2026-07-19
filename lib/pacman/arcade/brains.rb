# frozen_string_literal: true

module Pacman
  module Arcade
    # Each brain answers one question: where should this ghost head right now?
    module Brains
      class Chase
        def target(world)
          world.player.position
        end
      end

      class Ambush
        LOOKAHEAD = 4

        def target(world)
          player = world.player
          LOOKAHEAD.times.reduce(player.position) { |spot, _| spot.step(player.direction) }
        end
      end

      class Corner
        def initialize(corner:)
          @corner = corner
        end

        def target(_world)
          @corner
        end
      end

      class Wander
        def initialize(rng:)
          @rng = rng
        end

        def target(world)
          Position.new(
            row: @rng.rand(world.maze.height),
            col: @rng.rand(world.maze.width)
          )
        end
      end
    end
  end
end
