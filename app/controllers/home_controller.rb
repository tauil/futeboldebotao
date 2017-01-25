# coding: utf-8
class HomeController < ApplicationController
  def index
    @rankings_2015 = Ranking.by_year('2015').order('total_points DESC')
    @rankings_2016 = Ranking.by_year('2016').order('total_points DESC')
    @rankings_2017 = Ranking.by_year('2017').order('total_points DESC')
    @rankings_all = Ranking.by_year('all').order('total_points DESC')
    @match = Match.new
    @players_options = Player.find_each.collect {|p| [ p.name, p.id ] }
  end

  def comparison
    @results = []

    year = params[:year] || '2016'

    Player.find_each do |player|
      @results.push(results_for_player(player, year))
    end
  end

  def update_ranking
    if Ranking.updateit!
      flash[:success] = 'Ranking atualizado com sucesso!'
      redirect_to root_path
    else
      flash[:error] = 'Ocorreu um erro e não foi possível atualizar o ranking.'
    end
  end

  def results_for_player(player, year)
    result_for_player = { name_with_team: [player.name, player.team_name].join(' '),
                          compared_to: [] }

    Player.find_each do |player2|
      next if player.id == player2.id
      total_matches = Match.matches_for_player1_vs_player2(player.id, player2.id).by_year(year)
      matches_won = total_matches.unscoped_won(player.id)
      matches_draw = total_matches.unscoped_draw

      result = { name_with_team: [player2.name, player2.team_name].join(' ') }
      result[:total] = total_matches.count
      result[:won] = matches_won.count
      result[:draw] = matches_draw.count
      result[:lost] = total_matches.count - (matches_draw.count + matches_won.count)
      result[:goals_pro] = Match.goals_pro_for_player1_vs_player2(player.id, player2.id, year)
      result[:goals_against] = Match.goals_pro_for_player1_vs_player2(player2.id, player.id, year)

      result_for_player[:compared_to].push(result)
    end

    result_for_player
  end
end
