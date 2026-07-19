# frozen_string_literal: true

class CreateHighScores < ActiveRecord::Migration[8.1]
  def change
    create_table :high_scores do |t|
      t.string :name
      t.integer :score
      t.timestamps
    end
  end
end
