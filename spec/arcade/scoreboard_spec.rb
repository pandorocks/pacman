# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::Scoreboard do
  subject(:scoreboard) { described_class.new }

  it "scores 10 per pellet and 50 per power pellet" do
    scoreboard.pellet!
    scoreboard.power!

    expect(scoreboard.total).to eq(60)
  end

  it "doubles the ghost bonus within one frightened streak: 200, 400, 800, 1600" do
    bonuses = 4.times.map { scoreboard.ghost! }

    expect(bonuses).to eq([200, 400, 800, 1600])
    expect(scoreboard.total).to eq(3000)
  end

  it "starts the ghost bonus over after the streak resets" do
    scoreboard.ghost!
    scoreboard.reset_combo

    expect(scoreboard.ghost!).to eq(200)
  end
end
