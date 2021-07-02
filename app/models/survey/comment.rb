class Survey::Comment < ApplicationRecord
  belongs_to :poll, class_name: "Survey::Poll", optional: true, foreign_key: "survey_poll_id"

  scope :visible, -> { where(visible: true) }
  scope :invisible, -> { where(visible: false) }
  scope :filtered_for_current_user, lambda { |current_user|
    return all if current_user.admin_role?
    return visible if current_user.app_role?

    if current_user.editor_role?
      data_provider_ids = [current_user.data_provider_id] + User.restricted_role.map(&:data_provider_id)
      return includes(:poll).where(poll: { data_provider_id: data_provider_ids.compact.flatten })
    end

    includes(:poll).where(survey_polls: { data_provider_id: current_user.data_provider_id })
  }
end
