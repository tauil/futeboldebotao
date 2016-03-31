class AddYearToRankings < ActiveRecord::Migration
  def change
    add_column :rankings, :year, :date
  end
end
