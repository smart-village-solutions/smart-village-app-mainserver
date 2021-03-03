# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :notification do
    resources :wastes
    resources :devices do
      collection do
        delete "remove" => "devices#destroy"
        post "send_notification" => "devices#send_notification"
      end
    end
  end
  resources :categories
  resources :app_user_contents
  resources :static_contents
  get "data_provider", to: "data_provider#show", as: :data_provider
  get "data_provider/edit", as: :edit_data_provider
  post "data_provider/update", as: :update_data_provider
  resources :accounts do
    member do
      get "batch_defaults"
    end
  end

  use_doorkeeper do
    controllers applications: "oauth/applications"
  end

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  # if Rails.env.development?
  # end

  authenticate :user do
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    match "/background" => BetterDelayedJobWeb, anchor: false, via: [:get, :post]
  end

  post "/graphql", to: "graphql#execute"

  get "/generate_204", to: "application#generate_204", status: 204

  root to: "oauth/applications#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
