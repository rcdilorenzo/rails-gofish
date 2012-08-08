require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  attr_accessible :first_name, :last_name, :email, :screen_name, :password_hash

  has_many :results, :class_name => 'GameResult'
  has_many :addresses, :class_name => 'Address'

  validates :screen_name, :presence => true
  validates :first_name, :presence => true, :format => {
    :with => /^[a-zA-Z]+$/,
    :message => "Only letters allowed"
  }
  validates :last_name, :presence => true, :format => {
    :with => /^[a-zA-Z ]+$/,
    :message => "Only letters allowed"
  }
  validates :email, :presence => true
  validates :screen_name, :presence => true
  validates :password_hash, :presence => true

  after_save :determine_stats

  def password
    # http://bcrypt-ruby.rubyforge.org
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def wins
    determine_stats[:wins]
  end

  def losses
    determine_stats[:losses]
  end

  def ties
    determine_stats[:ties]
  end

  def games_played
    determine_stats[:games_played]
  end

  def determine_stats
    current_wins = 0
    current_losses = 0
    current_ties = 0
    current_games_played = 0
    results.map(&:game).each do |game|
      if game.end?
        if game.winner.is_a? GoFishPlayer
          current_wins += 1 if game.winner.include?(game.players.first)
          current_losses += 1 if !game.winner.include?(game.players.first)
        else
          current_ties += 1 if game.winner.include?(game.players.first)
          current_losses += 1 if !game.winner.include?(game.players.first)
        end
        current_games_played += 1
      end
    end
    return {:wins => current_wins, :losses => current_losses, :ties => current_ties, :games_played => current_games_played}
  end
end
