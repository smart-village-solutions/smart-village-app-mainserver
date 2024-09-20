# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  resources :municipalities do
    member do
      get :confirm_destroy
    end
  end
  namespace :notification do
    resources :wastes
    resources :devices do
      collection do
        delete "remove" => "devices#destroy"
        post "send_notifications" => "devices#send_notifications"
        post "send_notification/:id" => "devices#send_notification", as: :send_notification
      end

      member do
        get "exlusion_filter_config" => "devices#show_exclusion_config"
        put "exlusion_filter_config" => "devices#update_exclusion_config"
        patch "exlusion_filter_config" => "devices#update_exclusion_config"
      end
    end
    post "push_device_assignments/add" => "push_device_assignments#add", defaults: { format: "json" }
    delete "push_device_assignments/remove" => "push_device_assignments#remove", defaults: { format: "json" }
  end

  resources :categories
  resources :data_resources, only: %i[index]
  resources :app_user_contents
  resources :static_contents
  resources :media_contents, only: %i[create destroy], defaults: { format: "json" }
  get "data_provider", to: "data_provider#show", as: :data_provider
  get "data_provider/edit", as: :edit_data_provider
  post "data_provider/update", as: :update_data_provider
  resources :accounts do
    member do
      get "batch_defaults"
      get "batch_destroy_all"
      post "check_rss_feeds"
    end
  end
  resources :external_services

  get "/waste_calendar/export", to: "notification/wastes#ical_export", defaults: { format: "ics" }

  get "confirmation/error", to: "public/confirm_records#error"
  get "confirmation/:confirm_action/:token", to: "public/confirm_records#confirm", as: :confirm_record_action
  delete "confirmation/destroy/:token", to: "public/confirm_records#destroy"

  use_doorkeeper do
    controllers applications: "oauth/applications"
  end

  devise_for :members, module: "members", only: %i[omniauth_callbacks registrations sessions passwords]
  devise_for :users, controllers: { sessions: "users/sessions" }
  devise_for :admins
  authenticate :admin do
    match "/background" => BetterDelayedJobWeb, anchor: false, via: %i[get post]
  end

  get "user" => "users/status#show"
  get "member" => "members/status#show"
  post "/graphql", to: "graphql#execute"
  get "import_feeds", to: "import_feeds#index"

  namespace :api do
    namespace :v1 do
      resources :accounts, only: %i[show create update]
      post :resource_filters, to: "resource_filters#create", as: :save_resource_filter
    end
  end

  constraints(->(request) { MunicipalityConstraint.authorized?(request) }) do
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  get "/generate_204", to: "application#generate_204", status: 204

  get "/health-check" => "health_check#show"
  get "*not_found", to: "application#not_found_404", status: 404

  root to: redirect("accounts")
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
