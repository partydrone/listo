Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  root "pages#home"

  # Authentication routes
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/auth/logout" => "auth0#logout"
  get "/auth/redirect" => "auth0#redirect"

  # Public routes

  scope controller: :pages do
    get :up
  end

  # Secured routes
  get "/dashboard", to: "dashboard#show"
end
