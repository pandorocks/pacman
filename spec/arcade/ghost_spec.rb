# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Ghost do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  let(:direction) { Pacman::Arcade::Direction }

  let(:maze) do
    Pacman::Arcade::Maze.new(<<~MAZE)
      #####
      ##.##
      #...#
      ##.##
      #####
    MAZE
  end

  # A minimal stand-in for the World role a ghost collaborates with.
  world_role = Struct.new(:maze, :navigator, :rng, :mode, :player, keyword_init: true)

  let(:player) do
    Pacman::Arcade::Player.new(position: pos(1, 2), direction: direction.down)
  end

  let(:world) do
    world_role.new(
      maze: maze,
      navigator: Pacman::Arcade::Navigator.new(maze),
      rng: Random.new(1),
      mode: :chase,
      player: player
    )
  end

  let(:spawn) { Pacman::Arcade::Spawn.new(start: pos(3, 2), corner: pos(2, 4)) }

  subject(:ghost) do
    described_class.new(spawn: spawn, brain: Pacman::Arcade::Brains::Chase.new)
  end

  describe "#advance" do
    it "heads toward its brain's target in chase mode" do
      ghost.advance(world)

      expect(ghost.position).to eq(pos(2, 2))
    end

    it "heads toward its scatter corner in scatter mode" do
      world.mode = :scatter
      ghost.advance(world) # leaves the dead-end start upward
      ghost.advance(world)

      expect(ghost.position).to eq(pos(2, 3))
    end
  end

  describe "frightened and eaten states" do
    it "becomes edible when frightened and calm again afterwards" do
      ghost.frighten

      expect(ghost).to be_edible

      ghost.calm

      expect(ghost).not_to be_edible
    end

    it "returns home after being devoured and revives on arrival" do
      ghost.frighten
      ghost.advance(world)
      ghost.devour

      expect(ghost).not_to be_edible

      ghost.advance(world) until ghost.position == spawn.start

      expect(ghost).not_to be_eaten
    end
  end
end
