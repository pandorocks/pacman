# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Navigator do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  let(:direction) { Pacman::Arcade::Direction }

  # Open cross: center at (2,2) with corridors in all four directions.
  let(:maze) do
    Pacman::Arcade::Maze.new(<<~MAZE)
      #####
      ##.##
      #...#
      ##.##
      #####
    MAZE
  end

  subject(:navigator) { described_class.new(maze) }

  describe "#toward" do
    it "picks the open neighbor closest to the target" do
      chosen = navigator.toward(
        target: pos(0, 2), from: pos(2, 2), current: direction.right
      )

      expect(chosen).to eq(direction.up)
    end

    it "never reverses even when the target is behind" do
      chosen = navigator.toward(
        target: pos(2, 0), from: pos(2, 2), current: direction.right
      )

      expect(chosen).not_to eq(direction.left)
    end

    it "reverses only in a dead end" do
      chosen = navigator.toward(
        target: pos(2, 2), from: pos(1, 2), current: direction.up
      )

      expect(chosen).to eq(direction.down)
    end
  end

  describe "#wander" do
    it "picks a random open non-reversing neighbor using the injected rng" do
      rng = Random.new(42)

      choices = Array.new(20) do
        navigator.wander(from: pos(2, 2), current: direction.right, rng: rng)
      end

      expect(choices.uniq).to contain_exactly(direction.up, direction.down, direction.right)
    end
  end
end
