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

  let(:pellets) do
    Pacman::Arcade::PelletField.new(pellets: [pos(1, 2)], powers: [pos(1, 3)])
  end

  let(:scoreboard) { Pacman::Arcade::Scoreboard.new }

  subject(:world) do
    described_class.new(maze: maze, player: player, pellets: pellets, scoreboard: scoreboard)
  end

  describe "#tick" do
    it "moves the player and reports an eaten pellet" do
      events = world.tick

      expect(player.position).to eq(pos(1, 2))
      expect(events).to include(:pellet_eaten)
      expect(world.score).to eq(10)
      expect(pellets.remaining).to eq(1)
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

  describe "#queue_turn" do
    it "buffers a turn that the player takes at the next opening" do
      world.queue_turn(direction.down)

      world.tick

      expect(player.position).to eq(pos(2, 1))
    end
  end
end
