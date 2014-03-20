Soslide::Application.routes.draw do
  root 'sites#new'
  resources :sites, only: [ :new, :create, :show ]
end
