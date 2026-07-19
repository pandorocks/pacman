# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Sprites do
  let(:direction) { Pacman::Arcade::Direction }

  def block_count(lines)
    lines.join.count("█▀▄")
  end

  describe "dimensions" do
    it "always fills a scale x scale*2 cell" do
      [1, 2, 3, 5].each do |k|
        [
          described_class.player(scale: k, direction: direction.left),
          described_class.ghost(scale: k),
          described_class.frightened(scale: k),
          described_class.eaten(scale: k),
          described_class.cherry(scale: k)
        ].each do |lines|
          expect(lines.length).to eq(k)
          expect(lines.map(&:length).uniq).to eq([k * 2])
        end
      end
    end
  end

  describe ".player" do
    it "is a solid block at scale 1" do
      expect(described_class.player(scale: 1, direction: direction.left)).to eq(["██"])
    end

    it "opens its mouth toward the direction it faces" do
      left = described_class.player(scale: 3, direction: direction.left)
      right = described_class.player(scale: 3, direction: direction.right)

      middle = 1
      expect(left[middle][0, 3]).to include(" ")
      expect(right[middle][3, 3]).to include(" ")
      expect(left).not_to eq(right)
    end
  end

  describe ".ghost" do
    it "has a scalloped skirt rather than a flat bottom edge" do
      lines = described_class.ghost(scale: 3)

      expect(lines.last.strip.chars.uniq.length).to be > 1
    end

    it "has eye holes at larger scales" do
      solid = block_count([described_class.ghost(scale: 3).join])
      expect(described_class.ghost(scale: 3).join).to include(" ")
      expect(solid).to be > 0
    end
  end

  describe ".frightened" do
    it "renders dithered so it reads as vulnerable even without color" do
      expect(described_class.frightened(scale: 1)).to eq(["▒▒"])
      expect(described_class.frightened(scale: 3).join).to include("▒")
      expect(described_class.frightened(scale: 3).join).not_to include("█")
    end
  end

  describe ".cherry" do
    it "is a single berry at scale 1" do
      expect(described_class.cherry(scale: 1)).to eq(["● "])
    end

    it "grows berries below green-able stems at larger scales" do
      [2, 3, 4].each do |k|
        lines = described_class.cherry(scale: k)

        expect(lines.first).to include("│")
        expect(lines.first).not_to match(/[█▀▄]/)
        expect(lines.last).to match(/[█▀▄]/)
      end
    end
  end

  describe ".eaten" do
    it "is just the eyes heading home" do
      lines = described_class.eaten(scale: 3)

      expect(block_count(lines)).to be > 0
      expect(block_count(lines)).to be < block_count(described_class.ghost(scale: 3))
    end
  end
end
