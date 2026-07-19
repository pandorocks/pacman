# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Home::ShowView do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  describe "#render" do
    it "shows the title art and how to start" do
      view = described_class.new(
        home: Pacman::HomeState.new,
        theme: Pacman::Application.new.theme
      )

      rendered = strip_ansi(view.render)

      expect(rendered).to include("PAC-MAN")
      expect(rendered).to include("Enter")
    end
  end
end
