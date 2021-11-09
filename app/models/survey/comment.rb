# frozen_string_literal: true

class Survey::Comment < ApplicationRecord
  include FilterByRole

  belongs_to :poll, class_name: "Survey::Poll", optional: true, foreign_key: "survey_poll_id"

  # NOTE: this scope from `FilterByRole` needs to be overridden with adding `includes` for `poll`s
  scope :filtered_for_current_user, lambda { |current_user|
    return all if current_user.admin_role?
    return visible if current_user.app_role?

    if current_user.editor_role?
      data_provider_ids = [current_user.data_provider_id] + User.restricted_role.map(&:data_provider_id)
      return includes(:poll).where(survey_polls: { data_provider_id: data_provider_ids.compact.flatten })
    end

    includes(:poll).where(survey_polls: { data_provider_id: current_user.data_provider_id })
  }
end

# == Schema Information
#
# Table name: survey_comments
#
#  id             :bigint           not null, primary key
#  survey_poll_id :integer
#  message        :text(65535)
#  visible        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
