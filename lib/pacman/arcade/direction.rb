# frozen_string_literal: true

module Pacman
  module Arcade
    Direction = Data.define(:dy, :dx) do
      def self.up = @up ||= new(dy: -1, dx: 0)

      def self.down = @down ||= new(dy: 1, dx: 0)

      def self.left = @left ||= new(dy: 0, dx: -1)

      def self.right = @right ||= new(dy: 0, dx: 1)

      def self.all = [up, down, left, right]

      def opposite = Direction.new(dy: -dy, dx: -dx)
    end
  end
end
