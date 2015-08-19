class Match < ActiveRecord::Base
  belongs_to :player, polymorphic: true

  scope :won, -> { |player_id| where(winner_id: player_id) }
  scope :lost, -> { |player_id| where( Match.arel_table[:winner_id].is_not(player_id).
                                       and(Match.arel_table[:home_player_id].is(player_id).
                                           or(Match.arel_table[:visitor_player_id].is(player_id)))) }
end
