class CleanUpService
  def initialize
    @data_resource_types = DataResourceSetting::DATA_RESOURCES
    accounts = User.includes(:data_provider).all
    @data_providers = accounts.map(&:data_provider) if accounts.present? && accounts.any?
  end

  def perform
    return if @data_providers.blank?

    @data_providers.each do |data_provider|
      @data_resource_types.each do |data_resource_type|
        resource_configs = data_provider.data_resource_settings.where(data_resource_type: data_resource_type.to_s).first
        next if resource_configs.blank?
        next if resource_configs.settings.blank?

        cleanup_records = resource_configs.settings.fetch("cleanup_old_records", "false") == "true"
        next unless cleanup_records

        # die Ressourcen vom aktuellen data_provider und data_resource_type sollen bereinigt werden
        p "Cleanup records for data_provider #{data_provider.id} and #{data_resource_type}"
        cleanup_records_for(data_provider, data_resource_type)
      end
    end
  end

  def cleanup_records_for(data_provider, data_resource_type)
    external_references = ExternalReference.where(data_provider_id: data_provider.id, external_type: data_resource_type.to_s)

    return if external_references.blank? || external_references.count.zero?

    latest_import_date = external_references.order(:updated_at).last.try(:updated_at)

    return if latest_import_date.blank?

    # Lösche Einträge bis zum Datum: Mitternacht, 1 Tag vor dem letzten Import
    cleanup_records_to_date = (latest_import_date - 1.day).end_of_day
    resource_ids = external_references.where("updated_at < ?", cleanup_records_to_date).pluck(:external_id)

    p "Deleting #{resource_ids.count} records of #{data_resource_type}"

    # cancel deletion if all data of this data_provider would be deleted
    return if external_references.count == resource_ids.count

    data_resource_type.where(id: resource_ids).destroy_all
  end

end
