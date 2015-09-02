require 'rails_helper'

describe Player do
  let!(:match1) { FactoryGirl.create(:match, home_player_score: 3, visitor_player_score: 1) }
  let!(:match2) { FactoryGirl.create(:match, home_player_id: match1.home_player_id, home_player_score: 3, visitor_player_id: match1.visitor_player_id, visitor_player_score: 1) }
  let!(:player1) { match1.home_player }

  describe '.goals_pro' do
    it 'returns player 1 goals pro sum' do
      expect(Player.goals_pro(player1.id)).to eq(6)
    end
  end

  describe '.goals_against' do
    it 'return player 1 goals against sum' do
      expect(Player.goals_against(player1.id)).to eq(2)
    end
  end

  describe '#matches' do
    it 'returns the number of matches played by player 1' do
      expect(player1.matches).to match_array([match1, match2])
    end
  end

  describe '#goals_pro' do
    it 'returns player 1 goals pro sum' do
      expect(player1.goals_pro).to eq(6)
    end
  end

  describe '#goals_against' do
    it 'returns player 1 goals against sum' do
      expect(player1.goals_against).to eq(2)
    end
  end

  describe '#goals_balance' do
    it 'returns player 1 balance goals' do
      expect(player1.goals_balance).to eq(4)
    end
  end
end
