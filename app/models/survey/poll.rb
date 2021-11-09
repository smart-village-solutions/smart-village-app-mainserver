# frozen_string_literal: true

class Survey::Poll < ApplicationRecord
  include FilterByRole

  attr_accessor :force_create

  has_one :date, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_many :questions, class_name: "Survey::Question", foreign_key: "survey_poll_id", dependent: :destroy
  has_many :comments, class_name: "Survey::Comment", foreign_key: "survey_poll_id", dependent: :destroy

  belongs_to :data_provider

  store :title, coder: JSON
  store :description, coder: JSON

  accepts_nested_attributes_for :date, :questions, :data_provider

  before_save :set_visibility_by_role

  # Startdatum liegt in der Vergangenheit oder Heute und Enddatum liegt in der Zukunft oder Heute:
  scope :ongoing, lambda {
    where.not(fixed_dates: { date_start: [nil, ""] })
      .where.not(fixed_dates: { date_end: [nil, ""] })
      .where("fixed_dates.date_start <= ? AND fixed_dates.date_end >= ?", Date.today, Date.today)
      .joins(:date)
  }

  # Enddatum liegt in der Vergangenheit:
  scope :archived, lambda {
    where.not(fixed_dates: { date_end: [nil, ""] })
      .where("fixed_dates.date_end < ?", Date.today).joins(:date)
  }

  def question_id
    questions.try(:first).try(:id)
  end

  def question_title
    questions.try(:first).try(:title)
  end

  def archived?
    return false if date.blank?
    return false if date.date_end.blank?

    date.date_end < Date.today
  end

  def response_options
    # select all response options with at least one entry in a title for a language
    (questions.try(:first).try(:response_options) || []).select do |response_option|
      response_option.title.values.map(&:present?).include?(true) ||
        response_option.votes_count.positive?
    end
  end

  # Wenn die Rolle Restricted eine Umfrage anlegt oder bearbeitet,
  # so ist diese per default nicht sichtbar
  def set_visibility_by_role
    return unless data_provider
    return unless data_provider.user

    self.visible = false if data_provider.user.restricted_role?
  end
end

# == Schema Information
#
# Table name: survey_polls
#
#  id               :bigint           not null, primary key
#  title            :text(4294967295)
#  description      :text(4294967295)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  visible          :boolean          default(TRUE)
#  data_provider_id :integer
#
