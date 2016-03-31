require 'rails_helper'

describe Match do
  let!(:date_from_2015) { DateTime.new(2015, 10, 1, 20, 0) }
  let!(:date_from_2016) { DateTime.new(2016, 10, 1, 20, 0) }
  let!(:match1) { FactoryGirl.create(:match,
                                     home_player_score: 3,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match2) { FactoryGirl.create(:match,
                                     home_player_id: match1.home_player_id,
                                     home_player_score: 3,
                                     visitor_player_id: match1.visitor_player_id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match3) { FactoryGirl.create(:match,
                                     home_player_id: match1.home_player_id,
                                     home_player_score: 3,
                                     visitor_player_score: 3,
                                     occurred_at: date_from_2015 ) }
  let!(:match4) { FactoryGirl.create(:match,
                                     home_player_id: match1.home_player_id,
                                     home_player_score: 1,
                                     visitor_player_id: match1.visitor_player_id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match5) { FactoryGirl.create(:match,
                                     home_player_id: match1.home_player_id,
                                     home_player_score: 1,
                                     visitor_player_id: match1.visitor_player_id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2016 ) }
  let!(:player1) { match1.home_player }

  describe '.draw' do
    it 'returns draw matches count for player 1' do
      expect(described_class.draw(player1.id)).to match_array([match3, match4, match5])
    end
  end

  describe '.by_player' do
    it 'returns all matches from player' do
      expect(described_class.by_player(player1.id)).to match_array([match1, match2, match3, match4, match5])
    end
  end

  describe '.by_year' do
    it 'returns all matches from year' do
      expect(described_class.by_year(date_from_2016.year)).to match_array([match5])
    end
  end

  describe '.by_player.by_year' do
    it 'returns all matches from player and year' do
      expect(described_class.by_player(player1.id).by_year(date_from_2016.year)).to match_array([match5])
    end
  end
end
