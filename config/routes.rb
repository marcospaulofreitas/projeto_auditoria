Rails.application.routes.draw do
  root "quality_cases#index"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :quality_cases do
    member do
      get :gestao
      patch :aprovar
      patch :recusar
      get :pos_recusa
      patch :reanalisar
      patch :manter_avaliacao
      get :retorno_cliente
      post :registrar_retorno
      get :realizar_contato
      post :registrar_contato
      get :realizar_analise
      patch :analise_qualidade
    end
  end
  resources :teams do
    resources :team_memberships, only: [ :new, :create, :destroy ]
  end
  resources :operators

  get "operators_by_team/:team_id", to: "operators#by_team", as: :operators_by_team

  get "up" => "rails/health#show", as: :rails_health_check
end
