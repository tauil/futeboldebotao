FactoryGirl.define do
  factory :match do
    after(:build) do |r|
      if r.home_player_id.nil?
        player = FactoryGirl.create(:player)
        r.home_player_id = player.id
        r.winner_id = player.id if r.winner_id.nil?
      end
    end
    home_player_score 1
    after(:build) do |r|
      r.visitor_player_id = FactoryGirl.create(:player).id if r.visitor_player_id.nil?
    end
    visitor_player_score 1
  end

end
