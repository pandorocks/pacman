# frozen_string_literal: true

require "pacman"

RSpec.describe "Ghost brains" do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  let(:world) { Pacman::Arcade::World.classic }

  describe Pacman::Arcade::Brains::Chase do
    it "targets the player's current tile" do
      expect(subject.target(world)).to eq(world.player.position)
    end
  end

  describe Pacman::Arcade::Brains::Ambush do
    it "targets four tiles ahead of the player's facing direction" do
      ahead = world.player.position
      4.times { ahead = ahead.step(world.player.direction) }

      expect(subject.target(world)).to eq(ahead)
    end
  end

  describe Pacman::Arcade::Brains::Corner do
    it "always targets its assigned corner" do
      brain = described_class.new(corner: pos(1, 1))

      expect(brain.target(world)).to eq(pos(1, 1))
    end
  end

  describe Pacman::Arcade::Brains::Wander do
    it "targets random tiles from the injected rng" do
      brain = described_class.new(rng: Random.new(7))

      targets = Array.new(10) { brain.target(world) }

      expect(targets.uniq.length).to be > 1
      targets.each do |target|
        expect(target.row).to be_between(0, world.maze.height - 1)
        expect(target.col).to be_between(0, world.maze.width - 1)
      end
    end
  end
end
