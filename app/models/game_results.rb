class GameResults < ActiveRecord::Base
  attr_accessible :game_id, :player_scores, :winner
end
