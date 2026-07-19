# frozen_string_literal: true

module Pacman
  class HomeState < ApplicationState
    attribute :title, :string, default: "Pacman"
  end
end
