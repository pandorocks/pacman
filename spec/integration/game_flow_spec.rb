# frozen_string_literal: true

require "pacman"

RSpec.describe "Playing a game end to end" do
  def strip_ansi(string) = string.gsub(/\e\[[0-9;]*m/, "")

  def key(name) = Charming::Events::KeyEvent.new(key: name)

  it "boots to the title, starts on enter, and shows the live board" do
    backend = Charming::Internal::Terminal::MemoryBackend.new(
      events: [key(:enter), key(:left), key(:q)]
    )

    Charming::Runtime.new(Pacman::Application.new, backend: backend).run

    frames = backend.frames.map { |frame| strip_ansi(frame) }
    expect(frames.first).to include("PAC-MAN")
    expect(frames.last).to include("SCORE 0")
    expect(frames.last).to include("####")
  end
end
