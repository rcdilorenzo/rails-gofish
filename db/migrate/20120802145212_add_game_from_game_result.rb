class AddGameFromGameResult < ActiveRecord::Migration
  def change
    add_column :game_results, :game, :text
  end
end
