# frozen_string_literal: true

Rails.application.config.to_prepare do
  require "active_storage/blob"

  ActiveStorage::Blob.class_eval do
    def key
      self[:key] ||= [self.class.generate_unique_secure_token, filename.to_s].join("-")
    end
  end
end
