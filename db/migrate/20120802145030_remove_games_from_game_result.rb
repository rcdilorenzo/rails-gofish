class RemoveGamesFromGameResult < ActiveRecord::Migration
  def up
    remove_column :game_results, :games
  end

  def down
    add_column :game_results, :games, :text
  end
end
