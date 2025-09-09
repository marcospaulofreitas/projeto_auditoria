class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = Team.all
    
    # Filtro por nome
    if params[:nome].present?
      @teams = @teams.where("LOWER(nome) LIKE ?", "%#{params[:nome].downcase}%")
    end
    
    @teams = @teams.order(:nome)
  end

  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    
    if @team.save
      redirect_to teams_path, notice: 'Equipe criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: 'Equipe atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: 'Equipe excluída com sucesso.'
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:nome, operator_ids: [])
  end
end