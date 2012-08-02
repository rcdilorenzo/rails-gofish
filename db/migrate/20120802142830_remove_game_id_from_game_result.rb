class RemoveGameIdFromGameResult < ActiveRecord::Migration
  def up
    remove_column :game_results, :game_id
  end

  def down
    add_column :game_results, :game_id, :string
  end
end
