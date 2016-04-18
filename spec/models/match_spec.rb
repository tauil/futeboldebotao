require 'rails_helper'

describe Match do
  let!(:date_from_2015) { DateTime.new(2015, 10, 1, 20, 0) }
  let!(:date_from_2016) { DateTime.new(2016, 10, 1, 20, 0) }
  let!(:player1) { FactoryGirl.create(:player) }
  let!(:player2) { FactoryGirl.create(:player) }
  let!(:player3) { FactoryGirl.create(:player) }

  let!(:match1) { FactoryGirl.create(:match,
                                     home_player_id: player1.id,
                                     home_player_score: 3,
                                     visitor_player_id: player2.id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match2) { FactoryGirl.create(:match,
                                     home_player_id: player1.id,
                                     home_player_score: 3,
                                     visitor_player_id: player2.id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match3) { FactoryGirl.create(:match,
                                     home_player_id: player1.id,
                                     home_player_score: 3,
                                     visitor_player_id: player2.id,
                                     visitor_player_score: 3,
                                     occurred_at: date_from_2015 ) }
  let!(:match4) { FactoryGirl.create(:match,
                                     home_player_id: player1.id,
                                     home_player_score: 1,
                                     visitor_player_id: player2.id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2015 ) }
  let!(:match5) { FactoryGirl.create(:match,
                                     home_player_id: player1.id,
                                     home_player_score: 1,
                                     visitor_player_id: player2.id,
                                     visitor_player_score: 1,
                                     occurred_at: date_from_2016 ) }
  let!(:match6) { FactoryGirl.create(:match,
                                     home_player_id: player2.id,
                                     home_player_score: 1,
                                     visitor_player_id: player1.id,
                                     visitor_player_score: 2,
                                     occurred_at: date_from_2016 ) }
  let!(:match7) { FactoryGirl.create(:match,
                                     home_player_id: player2.id,
                                     home_player_score: 3,
                                     visitor_player_id: player1.id,
                                     visitor_player_score: 2,
                                     occurred_at: date_from_2016 ) }
  let!(:match8) { FactoryGirl.create(:match,
                                     home_player_id: player2.id,
                                     home_player_score: 1,
                                     visitor_player_id: player3.id,
                                     visitor_player_score: 2,
                                     occurred_at: date_from_2016 ) }

  describe '.draw' do
    it 'returns draw matches count for player 1' do
      expect(described_class.draw(player1.id)).to match_array([match3, match4, match5])
    end
  end

  describe '.by_player' do
    it 'returns all matches from player' do
      expect(described_class.by_player(player1.id)).to match_array([match1, match2, match3, match4, match5, match6, match7])
    end
  end

  describe '.by_year' do
    it 'returns all matches from year' do
      expect(described_class.by_year(date_from_2016.year)).to match_array([match5, match6, match7, match8])
    end
  end

  describe '.by_player.by_year' do
    it 'returns all matches from player and year' do
      expect(described_class.by_player(player1.id).by_year(date_from_2016.year)).to match_array([match5, match6, match7])
    end
  end

  describe 'module Comparison' do
    describe '.goals_pro_for_player1_vs_player2' do
      context 'when year param is 2015' do
        subject { described_class.goals_pro_for_player1_vs_player2(player1.id, player2.id, date_from_2015.year) }

        it 'returns goals pro from player1 over player2 in the given year' do
          expect(subject).to eq(10)
        end
      end

      context 'when year param is 2016' do
        subject { described_class.goals_pro_for_player1_vs_player2(player1.id, player2.id, date_from_2016.year) }

        it 'returns goals pro from player1 over player2 in the given year' do
          expect(subject).to eq(5)
        end
      end
    end

    describe '.matches_for_player1_vs_player2' do
      subject { described_class.matches_for_player1_vs_player2(player1.id, player2.id) }

      it 'returns all matches for player1 against player2' do
        expect(subject).to match_array([match1, match2, match3, match4, match5, match6, match7])
      end
    end
  end
end
