# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::BoardScale do
  let(:maze) { Pacman::Arcade::Maze.new(Pacman::Arcade::Layouts::CLASSIC) }

  def scale_for(width, height)
    described_class.new(screen: Charming::Screen.new(width: width, height: height), maze: maze)
  end

  describe "#factor" do
    it "picks the largest cell scale that fits the screen" do
      expect(scale_for(80, 24).factor).to eq(1)
      expect(scale_for(100, 40).factor).to eq(2)
      expect(scale_for(200, 50).factor).to eq(3)
    end
  end

  describe "#cramped?" do
    it "is cramped when not even a 1x board fits" do
      expect(scale_for(30, 10)).to be_cramped
      expect(scale_for(80, 24)).not_to be_cramped
    end
  end

  describe "#pace" do
    it "slows movement as the zoom grows so on-screen speed stays sane" do
      expect(scale_for(80, 24).pace).to eq(1)
      expect(scale_for(100, 40).pace).to eq(2)
      expect(scale_for(200, 50).pace).to eq(2)
      expect(scale_for(400, 80).pace).to eq(3)
    end

    it "never slows below a playable cap however huge the terminal" do
      expect(scale_for(2000, 400).pace).to eq(3)
    end
  end
end
