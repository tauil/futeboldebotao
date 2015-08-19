class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :player_id
      t.integer :matches_count
      t.integer :matches_won
      t.integer :matches_lost
      t.integer :goals_pro
      t.integer :goals_against
      t.integer :goals_difference

      t.timestamps null: false
    end

    add_index :rankings, :player_id
  end
end
