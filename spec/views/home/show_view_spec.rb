# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Home::ShowView do
  describe "#render" do
    it "renders the state title" do
      view = described_class.new(
        home: double(title: "Pacman"),
        theme: Pacman::Application.new.theme
      )

      expect(view.render).to include("Pacman")
    end
  end
end
