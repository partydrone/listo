Rails.application.routes.draw do
  # root "articles#index"

  get "/up/", to: "up#index", as: :up
  get "/up/databases", to: "up#databases", as: :up_databases
end
