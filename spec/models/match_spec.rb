require 'rails_helper'

describe Match do
  let!(:match1) { FactoryGirl.create(:match, home_player_score: 3, visitor_player_score: 1) }
  let!(:match2) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 3, visitor_player_id: match1.visitor_player_id, visitor_player_score: 1) }
  let!(:match3) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 3, visitor_player_score: 3) }
  let!(:match4) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 1, visitor_player_id: match1.visitor_player_id, visitor_player_score: 1) }
  let!(:player1) { match1.home_player }
  let!(:player2) { match1.visitor_player }
  let!(:player3) { match3.visitor_player }

  describe '.draw' do
    it 'returns draw matches count for player 1' do
      expect(described_class.draw(player1.id)).to match_array([match3, match4])
    end
  end
end
