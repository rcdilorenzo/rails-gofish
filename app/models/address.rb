class Address < ActiveRecord::Base
  attr_accessible :city, :country, :state, :street, :zip, :user_id
  belongs_to :user

  validates :street, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
end
