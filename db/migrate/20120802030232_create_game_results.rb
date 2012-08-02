class CreateGameResults < ActiveRecord::Migration
  def change
    create_table :game_results do |t|
      t.integer :game_id
      t.string :player_scores
      t.string :winner

      t.timestamps
    end
  end
end
