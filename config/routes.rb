Soslide::Application.routes.draw do
  resources :sites, only: [ :new ]
end
