class ChangeRankingYearColumnType < ActiveRecord::Migration
  def change
    change_column :rankings, :year, :string
  end
end
