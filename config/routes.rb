Soslide::Application.routes.draw do
  root 'sites#new'
  resources :sites, only: [ :new, :create, :show ]
  get "/pages/*id" => 'pages#show', as: :page, format: false
end
