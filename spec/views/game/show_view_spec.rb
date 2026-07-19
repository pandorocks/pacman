# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Game::ShowView do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  describe "#render" do
    it "stacks the HUD above the maze board" do
      view = described_class.new(world: Pacman::Arcade::World.classic)

      rendered = strip_ansi(view.render)

      expect(rendered).to include("SCORE 0")
      expect(rendered.index("SCORE 0")).to be < rendered.index("####")
    end
  end
end
