# frozen_string_literal: true

module Pacman
  module Arcade
    # The aggregate root: owns every actor and advances the whole game one tick
    # at a time. As the composition root it accepts the full cast — the wide
    # keyword list is deliberate and isolated behind the .classic factory.
    class World
      GHOST_STRIDE = 2
      FRIGHTENED_STRIDE = 3
      STARTING_LIVES = 3

      attr_reader :maze, :player, :pellets, :ghosts, :navigator, :rng, :lives

      def self.classic(rng: Random.new)
        maze = Maze.new(Layouts::CLASSIC)
        new(
          maze: maze,
          player: Player.new(position: maze.player_start, direction: Direction.left),
          pellets: PelletField.new(pellets: maze.pellet_positions, powers: maze.power_positions),
          scoreboard: Scoreboard.new,
          ghosts: classic_ghosts(maze, rng),
          schedule: ModeSchedule.new(scatter_ticks: 40, chase_ticks: 120, frightened_ticks: 50),
          rng: rng
        )
      end

      def self.classic_ghosts(maze, rng)
        corners = [
          Position.new(row: 1, col: maze.width - 2),
          Position.new(row: 1, col: 1),
          Position.new(row: maze.height - 2, col: maze.width - 2),
          Position.new(row: maze.height - 2, col: 1)
        ]
        brains = [Brains::Chase.new, Brains::Ambush.new, Brains::Wander.new(rng: rng), nil]
        maze.ghost_starts.each_with_index.map do |start, index|
          corner = corners.fetch(index % corners.length)
          Ghost.new(
            spawn: Spawn.new(start: start, corner: corner),
            brain: brains.fetch(index % brains.length) || Brains::Corner.new(corner: corner)
          )
        end
      end

      def initialize(maze:, player:, pellets:, scoreboard:, ghosts: [], schedule: nil, rng: Random.new)
        @maze = maze
        @player = player
        @pellets = pellets
        @scoreboard = scoreboard
        @ghosts = ghosts
        @schedule = schedule
        @rng = rng
        @navigator = Navigator.new(maze)
        @lives = STARTING_LIVES
        @ticks = 0
      end

      def tick
        @ticks += 1
        events = []
        events.concat(advance_schedule)
        player.advance(maze)
        events.concat(eat_at(player.position))
        advance_ghosts
        events.concat(resolve_collisions)
      end

      def queue_turn(direction)
        player.queue_turn(direction)
      end

      def score
        scoreboard.total
      end

      def mode
        schedule ? schedule.mode : :chase
      end

      private

      attr_reader :scoreboard, :schedule

      EATEN_EVENTS = {pellet: :pellet_eaten, power: :power_pellet}.freeze

      def eat_at(position)
        kind = pellets.eat(position)
        return [] unless kind

        scoreboard.public_send(:"#{kind}!")
        frighten_all if kind == :power
        [EATEN_EVENTS.fetch(kind)]
      end

      def frighten_all
        schedule&.frighten!
        ghosts.each(&:frighten)
        scoreboard.reset_combo
      end

      def advance_schedule
        return [] unless schedule
        return [] unless schedule.tick == :frightened_ended

        ghosts.each(&:calm)
        scoreboard.reset_combo
        [:frightened_ended]
      end

      def advance_ghosts
        ghosts.each { |ghost| ghost.advance(self) if moves_this_tick?(ghost) }
      end

      def moves_this_tick?(ghost)
        stride = ghost.edible? ? FRIGHTENED_STRIDE : GHOST_STRIDE
        (@ticks % stride).zero?
      end

      def resolve_collisions
        ghosts.select { |ghost| ghost.position == player.position }
          .flat_map { |ghost| resolve_collision(ghost) }
      end

      def resolve_collision(ghost)
        return [] if ghost.eaten?
        return devour(ghost) if ghost.edible?

        death
      end

      def devour(ghost)
        ghost.devour
        scoreboard.ghost!
        [:ghost_eaten]
      end

      def death
        @lives -= 1
        player.respawn
        ghosts.each(&:respawn)
        [:death]
      end
    end
  end
end
