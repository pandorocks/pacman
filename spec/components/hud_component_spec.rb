# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::HudComponent do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  let(:world) { Pacman::Arcade::World.classic }

  it "shows the score and remaining pellet count" do
    world.tick

    rendered = strip_ansi(described_class.new(world: world).render)

    expect(rendered).to include("SCORE 10")
    expect(rendered).to include("PELLETS #{world.pellets.remaining}")
  end

  it "shows remaining lives and the current level" do
    rendered = strip_ansi(described_class.new(world: world).render)

    expect(rendered).to include("LIVES 3")
    expect(rendered).to include("LEVEL 1")
  end
end
