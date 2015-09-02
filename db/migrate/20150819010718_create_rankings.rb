class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :player_id
      t.integer :matches_count
      t.integer :matches_won
      t.integer :matches_lost
      t.integer :matches_draw
      t.integer :goals_pro
      t.integer :goals_against
      t.integer :goals_difference
      t.integer :goals_balance
      t.integer :total_points

      t.timestamps null: false
    end

    add_index :rankings, :player_id
  end
end
