module FilterByRole
  extend ActiveSupport::Concern

  included do
    scope :visible, -> { where(visible: true) }
    scope :invisible, -> { where(visible: false) }
    scope :filtered_for_current_user, lambda { |current_user|
      return all if current_user.admin_role?
      return visible if current_user.app_role?
      return invisible.or(self.where(data_provider_id: current_user.data_provider_id)) if current_user.editor_role?

      where(data_provider_id: current_user.data_provider_id)
    }
  end

  def trash
    update_attribute :trashed, true
  end
end
