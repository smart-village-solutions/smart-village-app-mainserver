class CategoryService
  def update_all_defaults
    data_resource_types = DataResourceSetting::DATA_RESOURCES.map(&:to_s)
    data_provider_ids = User.all.map(&:data_provider_id)
    return if data_provider_ids.blank?

    data_provider_ids.each do |data_provider_id|
      data_resource_types.each do |data_resource_type|
        set_defaults(data_resource_type: data_resource_type, data_provider_id: data_provider_id)
      end
    end
  end

  def set_defaults(data_resource_type:, data_provider_id:)
    data_provider = DataProvider.find_by(id: data_provider_id)
    return if data_provider.blank?

    data_provider_settings = data_provider.settings(data_resource_type)
    return if data_provider_settings.blank?
    return unless data_provider_settings.has_default_categories?

    begin
      data_elements = data_provider.send(data_resource_type.underscore.pluralize)
    rescue StandardError
      return
    end

    data_elements.each do |data_element|
      category_ids_to_add = data_provider_settings.default_category_ids.map(&:to_i) - data_element.category_ids
      data_element.categories << Category.where(id: category_ids_to_add) if category_ids_to_add.present? && category_ids_to_add.any?
    end
  end

end
