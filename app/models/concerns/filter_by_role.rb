# frozen_string_literal: false

module FilterByRole
  extend ActiveSupport::Concern

  included do
    # der MunicipalityService setzt den :default_scope dei DataProvider auf die Kommune.
    # .all sind also hier nicht alle sondern nur alle innerhalb einer Municipality
    scope :by_data_provider, -> { where(data_provider_id: DataProvider.all.pluck(:id)) }

    scope :visible, -> { where(visible: true) }
    scope :invisible, -> { where(visible: false) }
    scope :filtered_for_current_user, lambda { |current_user|
      # Es wird ein Scope zurückgegeben, der nichts zurück gibt
      # wenn es keinen current_user gibt (bsp.: EventItem.none)
      return none if current_user.blank?

      return by_data_provider.all if current_user.admin_role?
      return by_data_provider.visible if current_user.app_role?
      return by_data_provider.visible if current_user.read_only_role?

      if current_user.editor_role?
        data_provider_ids = [current_user.data_provider_id] + User.restricted_role.map(&:data_provider_id)
        return where(data_provider_id: data_provider_ids.compact.flatten)
      end

      where(data_provider_id: current_user.data_provider_id)
    }
  end

  def trash
    update_attribute :trashed, true
  end
end
