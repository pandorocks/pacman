# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::GameOver::ShowView do
  describe "#render" do
    it "renders the state title" do
      view = described_class.new(game_over: double(title: "GameOver"))

      expect(view.render).to eq("GameOver")
    end
  end
end
