class User < ActiveRecord::Base
  attr_accessible :name
  has_many :results, :class_name => 'GameResult'

  validates :name, :presence => true, :format => {
    :with => /^[a-zA-Z]+$/,
    :message => "Only letters allowed"
  }

  def games
    results.map(&:game)
  end
end
