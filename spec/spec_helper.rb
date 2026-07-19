# frozen_string_literal: true

ENV["CHARMING_ENV"] ||= "test"

require "pacman"

RSpec.configure do |config|
  config.before(:each) do
    Pacman::HighScore.delete_all
  end
end
