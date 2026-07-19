# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Game::ShowView do
  describe "#render" do
    it "renders the state title" do
      view = described_class.new(game: double(title: "Game"))

      expect(view.render).to eq("Game")
    end
  end
end
