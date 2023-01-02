# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveStorage::Attachment.skip_callback(:commit, :after, :analyze_blob_later)
end
