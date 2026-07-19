# frozen_string_literal: true

Pacman::Application.routes do
  root "home#show"
  screen "/game", to: "game#show", title: "Game"
  screen "/game_over", to: "game_over#show", title: "GameOver"
end
