# coding: utf-8
class MatchesController < ApplicationController
  respond_to :html

  def index
  end

  def show
    @match = Match.find(params[:id])
  end

  def edit
    @match = Match.find(params[:id])
    @players_options = Player.find_each.collect {|p| [ p.name, p.id ] }
  end

  def create
    match = Match.new(match_params)

    if match.save
      flash[:success] = 'Partida criada com sucesso.'
      redirect_to root_path
    else
      flash[:error] = 'Não foi possível criar a partida.'
      render :index
    end
  end

  def update
    match = Match.find(params[:id])
    match.assign_attributes(match_params)

    if match.save
      flash[:success] = 'Partida atualizada com sucesso.'
      redirect_to root_path
    else
      flash[:error] = 'Não foi possível atualizar a partida.'
      render :edit
    end
  end

  def destroy
    match = Match.find(params[:id])

    if match.destroy
      flash[:success] = 'Partida apagada com sucesso.'
      redirect_to root_path
    else
      flash[:error] = 'Não foi possível apagar essa partida.'
      render :edit
    end
  end

  private

  def match_params
    params.require(:match).permit(:home_player_id, :home_player_score, :visitor_player_id, :visitor_player_score, :occurred_at)
  end
end
