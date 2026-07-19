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

  def doomed_world
    Pacman::Arcade::World.new(
      maze: Pacman::Arcade::Maze.new("#####\n#...#\n#####"),
      player: Pacman::Arcade::Player.new(
        position: Pacman::Arcade::Position.new(row: 1, col: 1),
        direction: Pacman::Arcade::Direction.right
      ),
      pellets: Pacman::Arcade::PelletField.new(pellets: [], powers: []),
      scoreboard: Pacman::Arcade::Scoreboard.new,
      ghosts: [
        Pacman::Arcade::Ghost.new(
          spawn: Pacman::Arcade::Spawn.new(
            start: Pacman::Arcade::Position.new(row: 1, col: 2),
            corner: Pacman::Arcade::Position.new(row: 1, col: 3)
          ),
          brain: Pacman::Arcade::Brains::Chase.new
        )
      ]
    )
  end

  # Small enough that the doomed mini maze renders at zoom 1, keeping pace 1.
  let(:tiny_screen) { Charming::Screen.new(width: 12, height: 5) }

  describe "losing the last life" do
    it "navigates to the game over screen carrying the final score" do
      doomed = doomed_world
      application.session[:states] = {game: Pacman::GameState.new(world: doomed)}

      responses = 3.times.map do
        described_class.new(application: application, screen: tiny_screen).dispatch(:advance)
      end

      expect(responses.last.navigate?).to be(true)
      expect(responses.last.path).to eq("/game_over")
      expect(application.session[:states][:game_over].score).to eq(doomed.score)
    end
  end

  describe "movement pacing at high zoom" do
    it "moves the world every second timer pulse on a large screen, skipping the repaint between" do
      big_screen = Charming::Screen.new(width: 200, height: 50)
      tick = Charming::Events::TimerEvent.new(name: :tick, now: 0)
      start = Pacman::Arcade::World.classic.player.position

      first = described_class.new(application: application, screen: big_screen, event: tick)
        .dispatch_timer
      world = application.session[:states][:game].world
      expect(first).to be_nil
      expect(world.player.position).to eq(start)

      described_class.new(application: application, screen: big_screen, event: tick).dispatch_timer
      expect(world.player.position).not_to eq(start)
    end
  end

  describe "high scores" do
    it "records the final score when the game ends" do
      doomed = doomed_world
      application.session[:states] = {game: Pacman::GameState.new(world: doomed)}

      3.times do
        described_class.new(application: application, screen: tiny_screen).dispatch(:advance)
      end

      expect(Pacman::HighScore.count).to eq(1)
      expect(Pacman::HighScore.first.score).to eq(doomed.score)
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
