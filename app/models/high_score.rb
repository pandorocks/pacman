# frozen_string_literal: true

module Pacman
  class HighScore < ApplicationRecord
    scope :top, ->(count) { order(score: :desc).limit(count) }
  end
end
