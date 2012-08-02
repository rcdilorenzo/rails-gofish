class AddGameResultIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :game_result_id, :integer
  end
end
