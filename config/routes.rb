Soslide::Application.routes.draw do
  root 'sites#new'
  resources :sites, only: [ :new, :create, :show, :index ]
  get "/pages/*id" => 'pages#show', as: :page, format: false
end
