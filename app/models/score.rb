class Score < ActiveRecord::Base
  attr_accessible :player_index, :score, :game_result_id
  belongs_to :game_result

  validates :player_index, :presence => true
  validates :score, :presence => true
end
