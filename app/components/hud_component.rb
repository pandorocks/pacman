# frozen_string_literal: true

module Pacman
  class HudComponent < Charming::Component
    def render
      row(
        text("SCORE #{world.score}", style: theme.title),
        text("PELLETS #{world.pellets.remaining}", style: theme.muted),
        gap: 4
      )
    end
  end
end
