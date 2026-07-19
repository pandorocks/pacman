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

  it "scales each cell into a block when given a scale factor" do
    lines = strip_ansi(described_class.new(world: world, scale: 2).render).split("\n")

    expect(lines.length).to eq(10)
    expect(lines[0]).to eq("#" * 20)
    expect(lines[2]).to eq("#### CC  .   oo ####")
    expect(lines[3]).to eq("#### CC         ####")
  end

  it "renders ghosts, drawing frightened ones differently" do
    ghost = Pacman::Arcade::Ghost.new(
      spawn: Pacman::Arcade::Spawn.new(start: pos(3, 3), corner: pos(1, 1)),
      brain: Pacman::Arcade::Brains::Chase.new
    )
    with_ghost = Pacman::Arcade::World.new(
      maze: world.maze,
      player: world.player,
      pellets: Pacman::Arcade::PelletField.new(pellets: [], powers: []),
      scoreboard: Pacman::Arcade::Scoreboard.new,
      ghosts: [ghost]
    )

    hungry = strip_ansi(described_class.new(world: with_ghost).render).split("\n")
    expect(hungry[3]).to eq("      M   ")

    ghost.frighten
    frightened = strip_ansi(described_class.new(world: with_ghost).render).split("\n")
    expect(frightened[3]).to eq("      m   ")
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
