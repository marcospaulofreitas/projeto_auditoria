class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login
  helper_method :current_operator, :logged_in?

  private

  def current_operator
    return nil unless session[:operator_id]

    @current_operator ||= Operator.find_by(id: session[:operator_id])

    # Se operador não existe, limpa a sessão
    if @current_operator.nil?
      session[:operator_id] = nil
    end

    @current_operator
  end

  def logged_in?
    !!current_operator
  end

  def require_login
    unless logged_in?
      redirect_to login_path
    end
  end
end
