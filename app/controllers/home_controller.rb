# coding: utf-8
class HomeController < ApplicationController
  def index
    @rankings_2015 = Ranking.by_year('2015').order('total_points DESC')
    @rankings_2016 = Ranking.by_year('2016').order('total_points DESC')
    @rankings_all = Ranking.by_year('all').order('total_points DESC')
    @match = Match.new
    @matches_by_occurrence = Match.all.order('occurred_at DESC, id ASC').group_by(&:occurred_at)
    @players_options = Player.find_each.collect {|p| [ p.name, p.id ] }
  end

  def update_ranking
    if Ranking.updateit!
      flash[:success] = 'Ranking atualizado com sucesso!'
      redirect_to root_path
    else
      flash[:error] = 'Ocorreu um erro e não foi possível atualizar o ranking.'
    end
  end
end
