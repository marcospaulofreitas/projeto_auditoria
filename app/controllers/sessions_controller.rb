class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
  end

  def create
    operator = Operator.find_by(email: params[:email])

    if operator && operator.authenticate(params[:password])
      session[:operator_id] = operator.id
      redirect_to root_path
    else
      flash.now[:alert] = "Email ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:operator_id] = nil
    redirect_to login_path
  end
end
