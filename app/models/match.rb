class Match < ActiveRecord::Base

  include Comparison

  belongs_to :home_player, class_name: 'Player', foreign_key: 'home_player_id'
  belongs_to :visitor_player, class_name: 'Player', foreign_key: 'visitor_player_id'

  scope :won, lambda { |player_id| where(winner_id: player_id) }
  scope :lost, lambda { |player_id| where( Match.arel_table[:winner_id].not_eq(player_id).
                                           and(Match.arel_table[:home_player_id].eq(player_id).
                                               or(Match.arel_table[:visitor_player_id].eq(player_id)))) }
  scope :draw, lambda { |player_id| where( Match.arel_table[:winner_id].eq(nil).
                                           and(Match.arel_table[:home_player_id].eq(player_id).
                                               or(Match.arel_table[:visitor_player_id].eq(player_id)))) }
  scope :by_player, lambda { |player_id| where(Match.arel_table[:home_player_id].eq(player_id).or(Match.arel_table[:visitor_player_id].eq(player_id))) }
  scope :by_year, lambda { |year| where( matches_by_occurred_at_arel(year) ) }

  scope :goals_pro, lambda { |player_id, year|
    matches = Arel::Table.new(:matches)

    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id))
    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id)).where(matches_by_occurred_at_arel(year)) unless all?(year)
    arel_home_score_query = arel_home_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:home_player_score] ], "home_total"))

    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id))
    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id)).where(matches_by_occurred_at_arel(year)) unless all?(year)
    arel_visitor_score_query = arel_visitor_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:visitor_player_score] ], "visitor_total"))

    ActiveRecord::Base.connection.execute(arel_home_score_query.to_sql).to_a.first['home_total'].to_i +
      ActiveRecord::Base.connection.execute(arel_visitor_score_query.to_sql).to_a.first['visitor_total'].to_i
  }

  scope :goals_against, lambda { |player_id, year|
    matches = Arel::Table.new(:matches)

    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id))
    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id).and(matches_by_occurred_at_arel(year))) unless all?(year)
    arel_home_score_query = arel_home_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:visitor_player_score] ], "home_total"))

    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id))
    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id).and(matches_by_occurred_at_arel(year))) unless all?(year)
    arel_visitor_score_query = arel_visitor_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:home_player_score] ], "visitor_total"))

    ActiveRecord::Base.connection.execute(arel_home_score_query.to_sql).to_a.first['home_total'].to_i +
      ActiveRecord::Base.connection.execute(arel_visitor_score_query.to_sql).to_a.first['visitor_total'].to_i
  }

  scope :goals_balance, lambda { | player_id, year|
    goals_pro(player_id, year) - goals_against(player_id, year)
  }

  scope :by_player_and_occurrence, lambda { |player_id, occurred_at|
    matches = Match.arel_table
    where( matches[:home_player_id].eq(player_id).
           or(matches[:visitor_player_id].eq(player_id)).
           and(matches[:occurred_at].eq(occurred_at)) )
  }

  before_validation :update_winner

  HALF_MATCH_PRICE = 2.5

  def update_winner
    self.winner_id = winner_player_id unless draw?
  end

  def self.years_with_data
    select(:occurred_at).map{|match| match.occurred_at.to_date.year.to_s }.uniq
  end

  private

  def self.all?(year)
    year == 'all'
  end

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

  def self.matches_by_occurred_at_arel(year)
    return if all?(year)
    Match.arel_table[:occurred_at].gteq(Date.parse("#{year}-1-1")).and(Match.arel_table[:occurred_at].lteq(Date.parse("#{year}-12-31")))
  end
end
