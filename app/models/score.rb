class Score < ActiveRecord::Base
  attr_accessible :player_index, :score, :game_result_id
  belongs_to :game 
end
