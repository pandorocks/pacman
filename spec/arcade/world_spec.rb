# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::World do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  let(:direction) { Pacman::Arcade::Direction }

  let(:maze) do
    Pacman::Arcade::Maze.new(<<~MAZE)
      #####
      #...#
      #.#.#
       ...
      #####
    MAZE
  end

  let(:player) do
    Pacman::Arcade::Player.new(position: pos(1, 1), direction: direction.right)
  end

  # The far pellet at (3,3) keeps the field from emptying mid-test (which would clear the level).
  let(:pellets) do
    Pacman::Arcade::PelletField.new(pellets: [pos(1, 2), pos(3, 3)], powers: [pos(1, 3)])
  end

  let(:scoreboard) { Pacman::Arcade::Scoreboard.new }

  subject(:world) do
    described_class.new(maze: maze, player: player, pellets: pellets, scoreboard: scoreboard)
  end

  describe ".classic" do
    it "assembles a world from the classic layout with the player at its start" do
      world = described_class.classic

      expect(world.player.position).to eq(world.maze.player_start)
      expect(world.pellets.remaining).to eq(
        world.maze.pellet_positions.size + world.maze.power_positions.size
      )
      expect(world.score).to eq(0)
    end
  end

  describe "#tick" do
    it "moves the player and reports an eaten pellet" do
      events = world.tick

      expect(player.position).to eq(pos(1, 2))
      expect(events).to include(:pellet_eaten)
      expect(world.score).to eq(10)
      expect(pellets.remaining).to eq(2)
    end

    it "reports a power pellet when the player lands on one" do
      world.tick
      events = world.tick

      expect(events).to include(:power_pellet)
      expect(world.score).to eq(60)
    end

    it "reports nothing when the player moves onto an empty cell" do
      2.times { world.tick }

      expect(world.tick).to be_empty
    end
  end

  def build_world(ghosts:, pellets: Pacman::Arcade::PelletField.new(pellets: [], powers: []))
    described_class.new(
      maze: maze,
      player: player,
      pellets: pellets,
      scoreboard: scoreboard,
      ghosts: ghosts,
      schedule: Pacman::Arcade::ModeSchedule.new(
        scatter_ticks: 100, chase_ticks: 1, frightened_ticks: 10
      ),
      rng: Random.new(3)
    )
  end

  def ghost_at(row, col)
    Pacman::Arcade::Ghost.new(
      spawn: Pacman::Arcade::Spawn.new(start: pos(row, col), corner: pos(3, 4)),
      brain: Pacman::Arcade::Brains::Chase.new
    )
  end

  describe "ghosts" do
    it "moves ghosts every second tick" do
      ghost = ghost_at(3, 1)
      world = build_world(ghosts: [ghost])

      world.tick
      expect(ghost.position).to eq(pos(3, 1))

      world.tick
      expect(ghost.position).to eq(pos(3, 2))
    end

    it "frightens ghosts when the player eats a power pellet" do
      ghost = ghost_at(3, 1)
      world = build_world(
        ghosts: [ghost],
        pellets: Pacman::Arcade::PelletField.new(pellets: [pos(3, 3)], powers: [pos(1, 2)])
      )

      events = world.tick

      expect(events).to include(:power_pellet)
      expect(ghost).to be_edible
    end

    it "costs a life and resets positions when a hungry ghost catches the player" do
      ghost = ghost_at(1, 2)
      world = build_world(ghosts: [ghost])

      events = world.tick

      expect(events).to include(:death)
      expect(world.lives).to eq(2)
      expect(player.position).to eq(pos(1, 1))
      expect(ghost.position).to eq(pos(1, 2))
    end

    it "devours a frightened ghost for bonus points" do
      ghost = ghost_at(1, 3)
      world = build_world(
        ghosts: [ghost],
        pellets: Pacman::Arcade::PelletField.new(pellets: [pos(3, 3)], powers: [pos(1, 2)])
      )

      world.tick
      events = world.tick

      expect(events).to include(:ghost_eaten)
      expect(ghost).to be_eaten
      expect(world.score).to eq(250)
    end
  end

  describe "losing" do
    it "ends the game when the last life is lost and goes inert" do
      world = build_world(ghosts: [ghost_at(1, 2)])

      3.times { world.tick }

      expect(world).to be_over
      expect(world.lives).to eq(0)
      expect(world.tick).to eq([])
    end
  end

  describe "levels" do
    it "clears the level when the last pellet is eaten, refills the maze, and speeds ghosts up" do
      ghost = ghost_at(3, 1)
      world = build_world(
        ghosts: [ghost],
        pellets: Pacman::Arcade::PelletField.new(pellets: [pos(1, 2)], powers: [])
      )

      events = world.tick

      expect(events).to include(:level_clear)
      expect(world.level).to eq(2)
      expect(world.pellets.remaining).to be > 0
      expect(world.player.position).to eq(pos(1, 1))

      world.tick

      expect(ghost.position).not_to eq(pos(3, 1))
    end
  end

  describe "#queue_turn" do
    it "buffers a turn that the player takes at the next opening" do
      world.queue_turn(direction.down)

      world.tick

      expect(player.position).to eq(pos(2, 1))
    end
  end
end
