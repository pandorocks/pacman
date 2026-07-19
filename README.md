# Pacman

A Pacman arcade clone built with the [Charming](https://github.com/pandorocks/charming)
terminal UI framework, as an end-to-end exercise of the framework and its generators.

## Screenshots
<img width="1256" height="1065" alt="image" src="https://github.com/user-attachments/assets/72cc474b-f54d-40aa-b622-6e203251e0ca" />


Run it with:

```sh
bundle exec pacman
```

## How to play

- **Enter** on the title screen starts a game.
- Steer with the **arrow keys** or **WASD** — turns are buffered and taken at the
  next opening, like the arcade.
- Eat every pellet to clear the level; levels get faster. Power pellets (`o`)
  frighten the ghosts — they turn blue and dithered — so you can eat them for
  combo bonuses (200/400/800/1600); eaten ghosts race home as floating eyes.
- The board scales to your terminal. At larger sizes the actors are drawn as
  half-block sprites: Pac-Man is a circle whose mouth points where he's headed,
  ghosts get their classic domed-and-scalloped shape.
- You have 3 lives. Game over shows the top-5 high score table (persisted in
  SQLite via `db/development.sqlite3`).
- **r**/**Enter** restarts from the game over screen; **q** quits anywhere;
  **ctrl+p** opens the command palette.

The four ghosts have distinct brains: one chases you, one ambushes four tiles
ahead, one wanders randomly, one patrols its corner. They alternate between
scatter and chase on a timer.

## Development

```sh
bundle exec rspec                      # full suite (game logic + controllers + views + integration)
CHARMING_ENV=test bundle exec charming db:migrate   # prepare the test database
```

Game rules live in plain Ruby under `lib/pacman/arcade/` (no TTY needed to test
them); the Charming app layer (controllers/views/components) is under `app/`.
Live game state is held in memory per run — it intentionally does not survive a
session's JSON serialization; only high scores persist.
