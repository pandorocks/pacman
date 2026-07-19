# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::GameOverController do
  let(:application) { Pacman::Application.new }

  subject(:controller) { described_class.new(application: application) }

  describe "#show" do
    it "renders the view with the state" do
      response = controller.dispatch(:show)

      expect(response).to respond_to(:body)
    end
  end
end
