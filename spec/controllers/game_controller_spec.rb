# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::GameController do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  let(:application) { Pacman::Application.new }

  subject(:controller) { described_class.new(application: application) }

  describe "#show" do
    it "renders the maze board with the starting score" do
      response = controller.dispatch(:show)

      expect(strip_ansi(response.body)).to include("####")
      expect(strip_ansi(response.body)).to include("SCORE 0")
    end
  end

  describe "#advance" do
    it "ticks the world and renders the updated score" do
      response = controller.dispatch(:advance)

      expect(strip_ansi(response.body)).to include("SCORE 10")
    end
  end

  describe "turn actions" do
    it "queues a turn that survives into a fresh controller's next tick" do
      controller.dispatch(:turn_right)

      described_class.new(application: application).dispatch(:advance)

      world = application.session[:states][:game].world
      expect(world.player.position).to eq(Pacman::Arcade::Position.new(row: 11, col: 10))
    end
  end
end
