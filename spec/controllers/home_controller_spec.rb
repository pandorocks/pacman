# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::HomeController do
  let(:application) { Pacman::Application.new }

  subject(:controller) { described_class.new(application: application) }

  describe "#show" do
    it "renders the view with the state" do
      response = controller.dispatch(:show)

      expect(response).to respond_to(:body)
    end
  end

  describe "#start_game" do
    it "navigates to the game screen" do
      response = controller.dispatch(:start_game)

      expect(response.navigate?).to be(true)
      expect(response.path).to eq("/game")
    end
  end
end
