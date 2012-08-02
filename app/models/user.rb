class User < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :results, :class_name => 'GameResult'

  def games
    results.map(&:game)
  end
end
