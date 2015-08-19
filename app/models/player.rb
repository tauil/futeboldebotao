class Player < ActiveRecord::Base
  has_many :matches, as: :home_player
  has_many :matches, as: :visitor_player
end
