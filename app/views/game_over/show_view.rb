# frozen_string_literal: true

module Pacman
  module GameOver
    class ShowView < Charming::View
      def render
        Charming::UI.center(
          column(banner, summary, high_score_table, hint, gap: 1),
          width: layout_screen.width,
          height: layout_screen.height
        )
      end

      private

      def banner
        text "GAME OVER", style: theme.title.bold
      end

      def high_score_table
        return "" if high_scores.empty?

        column(
          text("HIGH SCORES", style: theme.title),
          *high_scores.map.with_index(1) do |entry, rank|
            text("#{rank}. #{entry.name}  #{entry.score}", style: theme.info)
          end
        )
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
