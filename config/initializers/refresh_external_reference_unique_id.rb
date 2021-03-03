# frozen_string_literal: true

Rails.application.config.to_prepare do
  if ActiveRecord::Base.connected? && ActiveRecord::Base.connection.table_exists?("external_references")
    ExternalReference.pluck(:external_type).uniq.each do |type|
      ExternalReference.where(external_type: type).find_each do |entry|
        begin
          refreshed_unique_id = entry.external.unique_id
          break if entry.unique_id == refreshed_unique_id
        rescue
          break
        end

        entry.update_column(:unique_id, refreshed_unique_id)
      end
    end
  end
end
