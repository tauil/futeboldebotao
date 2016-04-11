module Comparison
  extend ActiveSupport::Concern

  included do
    scope :goals_pro_for_player1_vs_player2, lambda { |player1_id, player2_id, year|
      matches = Arel::Table.new(:matches)

      arel_home_score_query = matches.where(matches[:home_player_id].eq(player1_id).and(matches[:visitor_player_id].eq(player2_id)))
      arel_home_score_query = arel_home_score_query.where(matches_by_occurred_at_arel(year)) unless all?(year)
      arel_home_score_query = arel_home_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:home_player_score] ], "home_total"))

      arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player2_id).and(matches[:visitor_player_id].eq(player1_id)))
      arel_visitor_score_query = arel_visitor_score_query.where(matches_by_occurred_at_arel(year)) unless all?(year)
      arel_visitor_score_query = arel_visitor_score_query.project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:visitor_player_score] ], "visitor_total"))

      ActiveRecord::Base.connection.execute(arel_home_score_query.to_sql).to_a.first['home_total'].to_i +
        ActiveRecord::Base.connection.execute(arel_visitor_score_query.to_sql).to_a.first['visitor_total'].to_i
    }

    scope :matches_for_player1_vs_player2, lambda { |player1_id, player2_id|
      matches = Match.arel_table
      where( matches[:home_player_id].eq(player1_id).and(matches[:visitor_player_id].eq(player2_id)).
             or(matches[:home_player_id].eq(player2_id).and(matches[:visitor_player_id].eq(player1_id))) )
    }

    scope :won, lambda { |player_id|
      where(Match.arel_table[:winner_id].eq(player_id))
    }

    scope :draw, lambda { where(Match.arel_table[:winner_id].eq(nil)) }
  end
end
