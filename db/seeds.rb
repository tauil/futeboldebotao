# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
players = [ { email: 'rafael@tauil.com.br',
              name: 'Rafael B. Tauil',
              team_name: 'Ponte Preta' },
            { email: 'carlinhos',
              name: 'Carlinhos',
              team_name: 'Botafogo PB' },
            { email: 'kovacs',
              name: 'Leandro Kovacs',
              team_name: 'Bangu' },
            { email: 'rafaelco7',
              name: 'Rafael Cossetti',
              team_name: 'Juventus' } ]
players.each do |player_attributes|
  created_player = Player.create player_attributes
  puts "Created player: #{created_player.name}"
end
