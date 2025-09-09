class OperatorsController < ApplicationController
  before_action :set_operator, only: [:show, :edit, :update, :destroy]

  def index
    @operators = Operator.all
    
    # Filtro por nome
    if params[:nome].present?
      @operators = @operators.where("LOWER(nome) LIKE ?", "%#{params[:nome].downcase}%")
    end
    
    # Filtro por equipe
    if params[:equipe].present?
      @operators = @operators.joins(:teams).where(teams: { nome: params[:equipe] })
    end
    
    # Filtro por função
    if params[:funcao].present?
      @operators = @operators.where(funcao: params[:funcao])
    end
    
    @operators = @operators.order(:nome).distinct
  end

  def by_team
    team = Team.find(params[:team_id])
    operators = team.operators
    render json: operators.map { |o| { id: o.id, nome: o.nome, email: o.email } }
  end

  def show
  end

  

  def new
    @operator = Operator.new
    @teams = Team.all.order(:nome)
  end

  def create
    @operator = Operator.new(operator_params)
    
    if @operator.save
      redirect_to operators_path
    else
      @teams = Team.all.order(:nome)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @operator.password = nil
    @operator.password_confirmation = nil
    @teams = Team.all.order(:nome)
  end

  def update
    # Remove senha dos parâmetros se estiver em branco
    update_params = operator_params
    if update_params[:password].blank?
      update_params = update_params.except(:password, :password_confirmation)
    end
    
    if @operator.update(update_params)
      redirect_to operators_path
    else
      @teams = Team.all.order(:nome)
      render :edit, status: :unprocessable_entity
    end
  end

  def operator_params
    params.require(:operator).permit(:nome, :email, :funcao, :password, :password_confirmation, team_ids: [])
  end

  def destroy
    @operator.destroy
    redirect_to operators_path
  end

  private

  def set_operator
    @operator = Operator.find(params[:id])
  end

  
end