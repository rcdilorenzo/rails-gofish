class AddUserIdToGameResult < ActiveRecord::Migration
  def change
    add_column :game_results, :user_id, :integer
  end
end
