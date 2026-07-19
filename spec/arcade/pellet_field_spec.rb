# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::PelletField do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  subject(:field) do
    described_class.new(pellets: [pos(1, 1), pos(1, 2)], powers: [pos(2, 1)])
  end

  describe "#eat" do
    it "returns :pellet for a pellet cell and consumes it" do
      expect(field.eat(pos(1, 1))).to eq(:pellet)
      expect(field.eat(pos(1, 1))).to be_nil
    end

    it "returns :power for a power cell and consumes it" do
      expect(field.eat(pos(2, 1))).to eq(:power)
      expect(field.eat(pos(2, 1))).to be_nil
    end

    it "returns nil for an empty cell" do
      expect(field.eat(pos(9, 9))).to be_nil
    end
  end

  describe "#include? / #power?" do
    it "answers what remains at a position" do
      expect(field.include?(pos(1, 1))).to be(true)
      expect(field.power?(pos(2, 1))).to be(true)
      expect(field.power?(pos(1, 1))).to be(false)

      field.eat(pos(1, 1))

      expect(field.include?(pos(1, 1))).to be(false)
    end
  end

  describe "#empty? / #remaining" do
    it "empties as everything gets eaten" do
      expect(field.remaining).to eq(3)
      [pos(1, 1), pos(1, 2), pos(2, 1)].each { |p| field.eat(p) }

      expect(field).to be_empty
    end
  end
end
