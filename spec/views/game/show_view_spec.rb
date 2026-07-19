# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Game::ShowView do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  describe "#render" do
    it "asks for a bigger terminal instead of rendering a broken board" do
      view = described_class.new(
        world: Pacman::Arcade::World.classic,
        screen: Charming::Screen.new(width: 30, height: 10)
      )

      expect(view.render).to include("Terminal too small")
    end

    it "scales the board up and centers it on a large screen" do
      view = described_class.new(
        world: Pacman::Arcade::World.classic,
        screen: Charming::Screen.new(width: 100, height: 40)
      )

      lines = strip_ansi(view.render).split("\n")

      expect(lines.length).to eq(40)
      wall_line = lines.find { |line| line.include?("#" * 76) }
      expect(wall_line).not_to be_nil
      expect(wall_line.index("#")).to eq(12)
    end

    it "stacks the HUD above the maze board" do
      view = described_class.new(world: Pacman::Arcade::World.classic)

      rendered = strip_ansi(view.render)

      expect(rendered).to include("SCORE 0")
      expect(rendered.index("SCORE 0")).to be < rendered.index("####")
    end
  end
end
