Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'
  resources :matches, only: [:index, :new, :create, :show] do
    resources :entries
  end
end
