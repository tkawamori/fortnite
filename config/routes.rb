Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"},
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root 'homes#index'
  resources :matches, only: [:index, :new, :create, :show] do
    resources :entries
  end
end
