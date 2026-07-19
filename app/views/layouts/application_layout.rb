# frozen_string_literal: true

module Pacman
  module Layouts
    # Full-bleed layout: the game owns the whole terminal. No sidebar, no
    # borders — just the screen content with the command palette overlaid.
    class ApplicationLayout < Charming::View
      def render
        screen_layout(background: theme.background) do
          pane(:content, grow: 1) do
            yield_content
          end

          overlay command_palette_modal if command_palette_modal
        end
      end

      private

      def palette_component
        assigns.fetch(:palette, nil)
      end

      def command_palette_modal
        return unless palette_component

        render_component Charming::Components::CommandPaletteModal.new(
          content: palette_component,
          theme: theme
        )
      end
    end
  end
end
