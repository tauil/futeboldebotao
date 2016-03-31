class Ranking < ActiveRecord::Base
  VICTORY_POINT_MULTIPLIER = 3
  DRAW_POINT_MULTIPLIER = 1

  belongs_to :player

  scope :by_year, lambda { |year| where(year: Date.parse("#{year}-1-1")) }

  def self.updateit!
    Player.find_each do |player|
      Match.years_with_data.each do |year|
        player_rank = Ranking.by_year(year).where(player_id: player.id)

        if player_rank.count == 0
          create_player_rank(player, year)
        else
          update_player_rank(player_rank.first, year)
        end
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

  def self.create_player_rank(player, year)
    self.create! attributes_for_player_rank(player, year)
  end

  def self.update_player_rank(player_rank, year)
    player_rank.update_attributes! attributes_for_player_rank(player_rank.player, year)
  end

  def self.attributes_for_player_rank(player, year)
    { player_id: player.id,
      matches_count: matches_count(player.id, year),
      matches_won: matches_won_count(player.id, year),
      matches_draw: matches_draw_count(player.id, year),
      matches_lost: Match.lost(player.id).by_year(year).count,
      goals_pro: Match.goals_pro(player.id, year),
      goals_against: Match.goals_against(player.id, year),
      goals_balance: Match.goals_balance(player.id, year),
      total_points: calculate_points(player.id, year),
      year: Date.parse("#{year}-1-1") }
  end

  def self.matches_count(player_id, year)
    Match.by_player(player_id).by_year(year).count
  end

  def self.matches_won_count(player_id, year)
    Match.won(player_id).by_year(year).count
  end

  def self.matches_draw_count(player_id, year)
    Match.draw(player_id).by_year(year).count
  end

  def self.calculate_points(player_id, year)
    points_by_victory(player_id, year) + points_by_draw(player_id, year)
  end

  def self.points_by_victory(player_id, year)
    matches_won_count(player_id, year) * VICTORY_POINT_MULTIPLIER
  end

  def self.points_by_draw(player_id, year)
    matches_draw_count(player_id, year) * DRAW_POINT_MULTIPLIER
  end

  def total_points_played
    matches_count * VICTORY_POINT_MULTIPLIER
  end

  def matches_percent(matches_to_calculate_count)
    (matches_to_calculate_count.to_f * 100) / matches_count.to_f
  end
end
