class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :email
      t.string :name
      t.string :team_name

      t.timestamps null: false
    end

    add_index :players, :email, unique: true
  end
end
