class Ranking < ActiveRecord::Base
  VICTORY_POINT_MULTIPLIER = 3
  DRAW_POINT_MULTIPLIER = 1

  belongs_to :player

  def self.updateit!
    Player.find_each do |player|
      player_rank = Ranking.where(player_id: player.id)

      if player_rank.count == 0
        create_player_rank(player)
      else
        update_player_rank(player_rank.first)
      end
    end
    true
  end

  def utilization
    (total_points.to_f / total_points_played.to_f) * 100
  end

  def matches_won_percent
    matches_percent(matches_won)
  end

  def matches_draw_percent
    matches_percent(matches_draw)
  end

  def matches_lost_percent
    matches_percent(matches_lost)
  end

  private

  def self.create_player_rank(player)
    self.create!( player_id: player.id,
                  matches_count: player.matches.count,
                  matches_won: Match.won(player.id).count,
                  matches_draw: Match.draw(player.id).count,
                  matches_lost: Match.lost(player.id).count,
                  goals_pro: player.goals_pro,
                  goals_against: player.goals_against,
                  goals_balance: player.goals_balance,
                  total_points: calculate_points(player.id) )
  end

  def self.update_player_rank(player_rank)
    player_rank.update_attributes!( player_id: player_rank.player_id,
                                    matches_count: player_rank.player.matches.count,
                                    matches_won: Match.won(player_rank.player_id).count,
                                    matches_draw: Match.draw(player_rank.player_id).count,
                                    matches_lost: Match.lost(player_rank.player_id).count,
                                    goals_pro: player_rank.player.goals_pro,
                                    goals_against: player_rank.player.goals_against,
                                    goals_balance: player_rank.player.goals_balance,
                                    total_points: calculate_points(player_rank.player_id) )
  end

  def self.calculate_points(player_id)
    points_by_victory(player_id) + points_by_draw(player_id)
  end

  def self.points_by_victory(player_id)
    Match.won(player_id).count * VICTORY_POINT_MULTIPLIER
  end

  def self.points_by_draw(player_id)
    Match.draw(player_id).count * DRAW_POINT_MULTIPLIER
  end

  def total_points_played
    matches_count * VICTORY_POINT_MULTIPLIER
  end

  def matches_percent(matches_to_calculate_count)
    (matches_to_calculate_count.to_f * 100) / matches_count.to_f
  end
end
