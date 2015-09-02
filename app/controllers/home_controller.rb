# coding: utf-8
class HomeController < ApplicationController
  def index
    @rankings = Ranking.order('total_points DESC')
    @match = Match.new
    @matches_by_occurrence = Match.find_each.group_by(&:occurred_at)
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
