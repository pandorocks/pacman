# frozen_string_literal: true

module Pacman
  module GameOver
    class ShowView < Charming::View
      def render
        column(banner, summary, hint, gap: 1)
      end

      private

      def banner
        text "GAME OVER", style: theme.title.bold
      end

      def summary
        text "Final score #{game_over.score} · reached level #{game_over.level}", style: theme.info
      end

      def hint
        text "Press r or Enter to play again · q to quit", style: theme.muted
      end
    end
  end
end
