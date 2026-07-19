# frozen_string_literal: true

module Pacman
  module Arcade
    # ASCII maze layouts. Legend: `#` wall, `.` pellet, `o` power pellet,
    # `P` player start, `G` ghost start, space = open corridor (no pellet).
    # A row whose first and last cells are open is a wrap-around tunnel row.
    module Layouts
      CLASSIC = <<~MAZE
        ###################
        #o.......#.......o#
        #.##.###.#.###.##.#
        #.................#
        #.##.#.#####.#.##.#
        #....#.GGGG..#....#
        #.##.#.#####.#.##.#
         .................
        #.##.#.#####.#.##.#
        #....#...#...#....#
        #.##.###.#.###.##.#
        #........P........#
        #.##.###.#.###.##.#
        #o...#.......#...o#
        ###################
      MAZE
    end
  end
end
