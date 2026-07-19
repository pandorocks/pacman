# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::GameOver::ShowView do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  describe "#render" do
    it "shows the outcome with score and level" do
      view = described_class.new(
        game_over: Pacman::GameOverState.new(score: 990, level: 3),
        theme: Pacman::Application.new.theme
      )

      rendered = strip_ansi(view.render)

      expect(rendered).to include("GAME OVER")
      expect(rendered).to include("990")
      expect(rendered).to include("level 3")
    end
  end
end
