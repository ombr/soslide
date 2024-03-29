Soslide::Application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root 'sites#new'
  resources :sites, only: [:new, :create, :show, :index] do
    collection do
      get :login
      post :search
    end
  end
  get '/pages/*id' => 'pages#show', as: :page, format: false
end
