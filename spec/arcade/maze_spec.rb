# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Maze do
  subject(:maze) { described_class.new(Pacman::Arcade::Layouts::CLASSIC) }

  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  describe "#width / #height" do
    it "reads its dimensions from the layout text" do
      expect(maze.width).to eq(19)
      expect(maze.height).to eq(15)
    end
  end

  describe "CLASSIC layout invariants" do
    it "keeps every open cell reachable from the player start" do
      reachable = [maze.player_start].to_set
      frontier = [maze.player_start]
      while (current = frontier.pop)
        maze.open_neighbors(current).each do |neighbor|
          frontier << neighbor if reachable.add?(neighbor)
        end
      end

      open_cells = maze.pellet_positions + maze.power_positions + maze.ghost_starts
      expect(open_cells - reachable.to_a).to eq([])
    end
  end

  describe "#pellet_positions / #power_positions" do
    it "collects pellet and power markers, which never sit on walls or starts" do
      expect(maze.pellet_positions).to include(pos(1, 2))
      expect(maze.power_positions).to contain_exactly(pos(1, 1), pos(1, 17), pos(13, 1), pos(13, 17))
      expect(maze.pellet_positions).not_to include(maze.player_start, *maze.ghost_starts)
    end
  end

  describe "#open_neighbors" do
    it "returns adjacent non-wall positions" do
      expect(maze.open_neighbors(pos(1, 1))).to contain_exactly(pos(1, 2), pos(2, 1))
    end

    it "wraps through the tunnel at the maze edge" do
      expect(maze.open_neighbors(pos(7, 0))).to include(pos(7, 18))
    end
  end

  describe "#player_start / #ghost_starts" do
    it "reads the start markers from the layout" do
      expect(maze.player_start).to eq(pos(11, 9))
      expect(maze.ghost_starts).to eq([pos(5, 7), pos(5, 8), pos(5, 9), pos(5, 10)])
    end

    it "treats start markers as open corridor" do
      expect(maze.wall?(maze.player_start)).to be(false)
      expect(maze.wall?(maze.ghost_starts.first)).to be(false)
    end
  end

  describe "#wrap" do
    it "wraps a position that stepped off one edge onto the opposite edge" do
      expect(maze.wrap(pos(7, -1))).to eq(pos(7, 18))
      expect(maze.wrap(pos(7, 19))).to eq(pos(7, 0))
    end

    it "leaves in-bounds positions unchanged" do
      expect(maze.wrap(pos(3, 4))).to eq(pos(3, 4))
    end
  end

  describe "#wall?" do
    it "is true for wall cells and false for corridor cells" do
      expect(maze.wall?(pos(0, 0))).to be(true)
      expect(maze.wall?(pos(1, 1))).to be(false)
      expect(maze.wall?(pos(7, 0))).to be(false)
    end
  end
end
