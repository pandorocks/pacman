# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Player do
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

  describe "#advance" do
    it "moves one cell in its facing direction along an open corridor" do
      player = described_class.new(position: pos(1, 1), direction: direction.right)

      player.advance(maze)

      expect(player.position).to eq(pos(1, 2))
    end

    it "applies a queued turn as soon as that way is open" do
      player = described_class.new(position: pos(1, 1), direction: direction.right)
      player.queue_turn(direction.down)

      player.advance(maze)

      expect(player.position).to eq(pos(2, 1))
      expect(player.direction).to eq(direction.down)
    end

    it "keeps moving in its current direction while the queued turn is blocked" do
      player = described_class.new(position: pos(1, 1), direction: direction.right)
      player.queue_turn(direction.up)

      player.advance(maze)

      expect(player.position).to eq(pos(1, 2))
      expect(player.direction).to eq(direction.right)
    end

    it "wraps through the tunnel to the opposite edge" do
      player = described_class.new(position: pos(3, 0), direction: direction.left)

      player.advance(maze)

      expect(player.position).to eq(pos(3, 4))
    end

    it "stops when facing a wall" do
      player = described_class.new(position: pos(1, 1), direction: direction.up)

      player.advance(maze)

      expect(player.position).to eq(pos(1, 1))
    end
  end
end
