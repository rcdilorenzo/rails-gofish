class GameResult < ActiveRecord::Base
  attr_accessible :game, :player_scores, :winner, :user_id
  has_many :player_scores, :class_name => 'Score'
  serialize :game
  belongs_to :user

  validates :game, :presence => true
  # validates :winner, :presence => true, :if => Proc.new { game.end? }
  # validates :player_scores, :presence => true, :if => Proc.new { game.end? }
  
  def to_s
    {"id" => id, "player_scores" => player_scores, "winner" => winner, "user_id" => user_id}
  end

  def inspect
    {"id" => id, "player_scores" => player_scores, "winner" => winner, "user_id" => user_id}
  end
end
