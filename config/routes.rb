# frozen_string_literal: true

Rails.application.routes.draw do
  resources :municipalities
  namespace :notification do
    resources :wastes
    resources :devices do
      collection do
        delete "remove" => "devices#destroy"
        post "send_notifications" => "devices#send_notifications"
        post "send_notification/:id" => "devices#send_notification", as: :send_notification
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

  get "/waste_calendar/export", to: "notification/wastes#ical_export", defaults: { format: "ics" }

  use_doorkeeper do
    controllers applications: "oauth/applications"
  end

  devise_for :admins
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  get "user" => "users/status#show"

  authenticate :user do
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    match "/background" => BetterDelayedJobWeb, anchor: false, via: [:get, :post]
  end

  post "/graphql", to: "graphql#execute"

  get "/generate_204", to: "application#generate_204", status: 204

  root to: redirect("accounts")
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
