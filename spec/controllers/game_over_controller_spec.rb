# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::GameOverController do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  let(:application) { Pacman::Application.new }

  subject(:controller) { described_class.new(application: application) }

  describe "#show" do
    it "shows the final score and how to play again" do
      application.session[:states] = {
        game_over: Pacman::GameOverState.new(score: 1230, level: 2)
      }

      body = strip_ansi(controller.dispatch(:show).body)

      expect(body).to include("GAME OVER")
      expect(body).to include("1230")
      expect(body).to include("r")
    end
  end

  describe "#restart" do
    it "starts a fresh game" do
      response = controller.dispatch(:restart)

      expect(response.navigate?).to be(true)
      expect(response.path).to eq("/game")
    end
  end
end
