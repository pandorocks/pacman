# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Position do
  subject(:position) { described_class.new(row: 3, col: 5) }

  describe "#step" do
    it "returns the adjacent position in the given direction" do
      stepped = position.step(Pacman::Arcade::Direction.up)

      expect(stepped).to eq(described_class.new(row: 2, col: 5))
    end
  end

  describe "value equality" do
    it "treats positions with the same coordinates as the same hash key" do
      twin = described_class.new(row: 3, col: 5)

      expect({position => true}).to have_key(twin)
    end
  end

  describe "#distance_sq" do
    it "returns the squared euclidean distance to another position" do
      other = described_class.new(row: 0, col: 1)

      expect(position.distance_sq(other)).to eq(25)
    end
  end
end
