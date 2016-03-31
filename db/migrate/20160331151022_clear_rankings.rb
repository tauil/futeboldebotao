class ClearRankings < ActiveRecord::Migration
  def change
    Ranking.delete_all
    Ranking.updateit!
  end
end
