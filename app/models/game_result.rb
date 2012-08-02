class GameResult < ActiveRecord::Base
  attr_accessible :game, :player_scores, :winner, :user_id
  serialize :game
  belongs_to :user
end
