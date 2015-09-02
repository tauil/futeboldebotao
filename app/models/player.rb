class Player < ActiveRecord::Base
  has_many :matches_as_home, class_name: 'Match', dependent: :destroy, foreign_key: 'home_player_id'
  has_many :matches_as_visitor, class_name: 'Match', dependent: :destroy, foreign_key: 'visitor_player_id'
  has_one :ranking, dependent: :destroy

  scope :goals_pro, lambda { |player_id|
    matches = Arel::Table.new(:matches)
    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id)).
                            project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:home_player_score] ], "home_total"))
    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id)).
                               project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:visitor_player_score] ], "visitor_total"))

    ActiveRecord::Base.connection.execute(arel_home_score_query.to_sql).to_a.first['home_total'].to_i +
      ActiveRecord::Base.connection.execute(arel_visitor_score_query.to_sql).to_a.first['visitor_total'].to_i
  }

  scope :goals_against, lambda { |player_id|
    matches = Arel::Table.new(:matches)
    arel_home_score_query = matches.where(matches[:home_player_id].eq(player_id)).
                            project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:visitor_player_score] ], "home_total"))
    arel_visitor_score_query = matches.where(matches[:visitor_player_id].eq(player_id)).
                               project(Arel::Nodes::NamedFunction.new("SUM", [ matches[:home_player_score] ], "visitor_total"))

    ActiveRecord::Base.connection.execute(arel_home_score_query.to_sql).to_a.first['home_total'].to_i +
      ActiveRecord::Base.connection.execute(arel_visitor_score_query.to_sql).to_a.first['visitor_total'].to_i
  }

  def matches
    matches_as_home + matches_as_visitor
  end

  def goals_pro
    Player.goals_pro(id)
  end

  def goals_against
    Player.goals_against(id)
  end

  def goals_balance
    Player.goals_pro(id) - Player.goals_against(id)
  end
end
