class GameResult < ActiveRecord::Base
  attr_accessible :game, :player_scores, :winner, :user_id
  has_many :player_scores, :class_name => 'Score'
  serialize :game
  belongs_to :user

  validates :game, :presence => true
end
