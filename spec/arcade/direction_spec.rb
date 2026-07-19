# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Direction do
  describe ".up/.down/.left/.right" do
    it "exposes the four cardinal directions with their row/col deltas" do
      expect([described_class.up.dy, described_class.up.dx]).to eq([-1, 0])
      expect([described_class.down.dy, described_class.down.dx]).to eq([1, 0])
      expect([described_class.left.dy, described_class.left.dx]).to eq([0, -1])
      expect([described_class.right.dy, described_class.right.dx]).to eq([0, 1])
    end
  end

  describe "#opposite" do
    it "returns the reverse direction" do
      expect(described_class.up.opposite).to eq(described_class.down)
      expect(described_class.left.opposite).to eq(described_class.right)
    end
  end
end
