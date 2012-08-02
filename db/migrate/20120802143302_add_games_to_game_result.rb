class AddGamesToGameResult < ActiveRecord::Migration
  def change
    add_column :game_results, :games, :text
  end
end
