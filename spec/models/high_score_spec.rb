# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::HighScore do
  it "inherits from ApplicationRecord" do
    expect(described_class.superclass).to eq(Pacman::ApplicationRecord)
  end
end
