class Player < ActiveRecord::Base
  has_many :matches_as_home, class_name: 'Match', dependent: :destroy, foreign_key: 'home_player_id'
  has_many :matches_as_visitor, class_name: 'Match', dependent: :destroy, foreign_key: 'visitor_player_id'
  has_one :ranking, dependent: :destroy
end
