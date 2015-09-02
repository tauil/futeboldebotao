class RemoveGoalsDifferenceFromRankings < ActiveRecord::Migration
  def change
    remove_column :rankings, :goals_difference, :integer
  end
end
