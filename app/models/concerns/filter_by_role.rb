# frozen_string_literal: false

module FilterByRole
  extend ActiveSupport::Concern

  included do
    scope :visible, -> { where(visible: true) }
    scope :invisible, -> { where(visible: false) }
    scope :filtered_for_current_user, lambda { |current_user|
      return all if current_user.admin_role? || current_user.extended_user_role?
      return visible if current_user.app_role?
      return visible if current_user.read_only_role?

      # if current_user has role editor
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
