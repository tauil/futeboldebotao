class Match < ActiveRecord::Base
  belongs_to :home_player, class_name: 'Player', foreign_key: 'home_player_id'
  belongs_to :visitor_player, class_name: 'Player', foreign_key: 'visitor_player_id'

  scope :won, lambda { |player_id| where(winner_id: player_id) }
  scope :lost, lambda { |player_id| where( Match.arel_table[:winner_id].not_eq(player_id).
                                           and(Match.arel_table[:home_player_id].eq(player_id).
                                               or(Match.arel_table[:visitor_player_id].eq(player_id)))) }
  scope :draw, lambda { |player_id| where( Match.arel_table[:winner_id].eq(nil).
                                           and(Match.arel_table[:home_player_id].eq(player_id).
                                               or(Match.arel_table[:visitor_player_id].eq(player_id)))) }

  before_validation :update_winner

  def update_winner
    self.winner_id = winner_player_id unless draw?
  end

  private

  def draw?
    self.home_player_score == self.visitor_player_score
  end

  def winner_player_id
    if self.home_player_score > self.visitor_player_score
      self.home_player_id
    else
      self.visitor_player_id
    end
  end
end
