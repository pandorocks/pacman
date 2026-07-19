# frozen_string_literal: true

module Pacman
  module Home
    class ShowView < Charming::View
      LOGO = <<~ART
        ██████╗  █████╗  ██████╗      ███╗   ███╗ █████╗ ███╗   ██╗
        ██╔══██╗██╔══██╗██╔════╝█████╗████╗ ████║██╔══██╗████╗  ██║
        ██████╔╝███████║██║     ╚════╝██╔████╔██║███████║██╔██╗ ██║
        ██╔═══╝ ██╔══██║██║           ██║╚██╔╝██║██╔══██║██║╚██╗██║
        ██║     ██║  ██║╚██████╗      ██║ ╚═╝ ██║██║  ██║██║ ╚████║
        ╚═╝     ╚═╝  ╚═╝ ╚═════╝      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
      ART

      def render
        Charming::UI.center(
          column(logo_block, subtitle, start_hint, controls_hint, gap: 1),
          width: layout_screen.width,
          height: layout_screen.height
        )
      end

      private

      def logo_block
        text LOGO.chomp, style: theme.title
      end

      def subtitle
        text "PAC-MAN — a Charming arcade clone", style: theme.info
      end

      def start_hint
        text "Press Enter to start", style: theme.title.bold
      end

      def controls_hint
        text "Arrows or WASD to steer · q to quit", style: theme.muted
      end
    end
  end
end
