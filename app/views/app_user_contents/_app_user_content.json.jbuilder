# frozen_string_literal: true

json.extract! app_user_content, :id, :data_type, :data_source, :content, :created_at, :updated_at
json.url app_user_content_url(app_user_content, format: :json)
