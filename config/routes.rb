# frozen_string_literal: true

Pacman::Application.routes do
  root "home#show"
  screen "/game", to: "game#show", title: "Game"
end
