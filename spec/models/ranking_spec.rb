require 'rails_helper'

describe Ranking do
  let!(:match1) { FactoryGirl.create(:match, home_player_score: 3, visitor_player_score: 1) }
  let!(:match2) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 3, visitor_player_id: match1.visitor_player_id, visitor_player_score: 1) }
  let!(:match3) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 3, visitor_player_score: 3) }
  let!(:player1) { match1.home_player }
  let!(:player2) { match1.visitor_player }
  let!(:player3) { match3.visitor_player }

  describe '#updateit!' do
    it 'updates ranking based on players count' do
      described_class.updateit!
      expect(described_class.count).to eq(3)
    end
  end
end
