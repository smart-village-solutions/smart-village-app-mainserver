# frozen_string_literal: true

if ActiveRecord::Base.connection.table_exists?("external_references")
  ExternalReference.pluck(:external_type).uniq.each do |type|
    ExternalReference.where(external_type: type).find_each do |entry|
      unique_id = entry.external.unique_id
      break if entry.unique_id == unique_id

      entry.update_column(:unique_id, unique_id)
    end
  end
end
