# frozen_string_literal: true

require "pacman"

RSpec.describe Pacman::BoardComponent do
  def pos(row, col) = Pacman::Arcade::Position.new(row: row, col: col)

  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  let(:world) do
    Pacman::Arcade::World.new(
      maze: Pacman::Arcade::Maze.new("#####\n#...#\n#.#.#\n ...\n#####"),
      player: Pacman::Arcade::Player.new(
        position: pos(1, 1), direction: Pacman::Arcade::Direction.right
      ),
      pellets: Pacman::Arcade::PelletField.new(pellets: [pos(1, 2)], powers: [pos(1, 3)]),
      scoreboard: Pacman::Arcade::Scoreboard.new
    )
  end

  it "renders walls, pellets, power pellets, and the player as two-char cells" do
    lines = strip_ansi(described_class.new(world: world).render).split("\n")

    expect(lines).to eq([
      "##########",
      "##C . o ##",
      "##  ##  ##",
      "          ",
      "##########"
    ])
  end
end
