# frozen_string_literal: true

class Survey::Comment < ApplicationRecord
  include FilterByRole

  belongs_to :poll, class_name: "Survey::Poll", optional: true, foreign_key: "survey_poll_id"

  # NOTE: this scope from `FilterByRole` needs to be overridden with adding `includes` for `poll`s
  scope :filtered_for_current_user, lambda { |current_user|
    # Es wird ein Scope zurückgegeben, der nichts zurück gibt
    # wenn es keinen current_user gibt (Survey::Comment.none)
    return none if current_user.blank?

    # der MunicipalityService setzt den :default_scope dei DataProvider auf die Kommune.
    if current_user.admin_role? || current_user.app_role?
      data_provider_ids = DataProvider.all.pluck(:id)
    elsif current_user.editor_role?
      data_provider_ids = [current_user.data_provider_id] + User.restricted_role.map(&:data_provider_id)
    else
      data_provider_ids = current_user.data_provider_id
    end

    comment_scope = includes(:poll).where(survey_polls: { data_provider_id: data_provider_ids })
    return comment_scope.visible if current_user.app_role?

    comment_scope
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
