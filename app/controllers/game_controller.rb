# frozen_string_literal: true

module Pacman
  class GameController < ApplicationController
    layout false

    timer :tick, every: 0.12, action: :advance

    key "up", :turn_up, scope: :global
    key "down", :turn_down, scope: :global
    key "left", :turn_left, scope: :global
    key "right", :turn_right, scope: :global
    key "w", :turn_up, scope: :global
    key "s", :turn_down, scope: :global
    key "a", :turn_left, scope: :global
    key "d", :turn_right, scope: :global

    def show
      render :show, world: world, palette: command_palette
    end

    def advance
      world.tick
      show
    end

    def turn_up = turn(Arcade::Direction.up)

    def turn_down = turn(Arcade::Direction.down)

    def turn_left = turn(Arcade::Direction.left)

    def turn_right = turn(Arcade::Direction.right)

    private

    def turn(direction)
      world.queue_turn(direction)
      show
    end

    def world
      game.world ||= Arcade::World.classic
    end

    def game
      state(:game, GameState)
    end
  end
end
