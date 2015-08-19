class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_player_id
      t.integer :home_player_score
      t.integer :visitor_player_id
      t.integer :visitor_player_score
      t.integer :winner_id

      t.timestamps null: false
    end

    add_index :matches, :home_player_id
    add_index :matches, :visitor_player_id
    add_index :matches, :winner_id
  end
end
