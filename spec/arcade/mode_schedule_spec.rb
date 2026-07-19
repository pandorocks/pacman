# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::Arcade::ModeSchedule do
  subject(:schedule) do
    described_class.new(scatter_ticks: 3, chase_ticks: 4, frightened_ticks: 2)
  end

  it "starts in scatter and alternates with chase on the tick cadence" do
    modes = Array.new(8) do
      schedule.tick
      schedule.mode
    end

    expect(modes).to eq(
      [:scatter, :scatter, :chase, :chase, :chase, :chase, :scatter, :scatter]
    )
  end

  describe "#frighten!" do
    it "overrides the cycle until the countdown expires, then reports the end" do
      schedule.frighten!

      expect(schedule.mode).to eq(:frightened)
      expect(schedule.tick).to be_nil
      expect(schedule.tick).to eq(:frightened_ended)
      expect(schedule.mode).to eq(:scatter)
    end
  end
end
