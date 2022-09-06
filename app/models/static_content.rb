# frozen_string_literal: true

class StaticContent < ApplicationRecord
  # we need the scope for destroying records, which only admins and editors are allowed to
  scope :filtered_for_current_user, lambda { |current_user|
    return all if current_user.admin_role?
    return all if current_user.editor_role?

    none
  }

  attr_accessor :force_create

  validates_presence_of :name, :data_type
  validates :name, uniqueness: { case_sensitive: false, scope: :version }

  scope :filter_by_type, ->(type) { where data_type: type }

  before_validation :enforce_nil_for_empty_version

  include Sortable
  sortable_on :name, :id

  include Searchable
  searchable_on :name

  def self.sorted_and_filtered_for_params(params)
    sorted_results = sorted_for_params(params)
    sorted_results = sorted_results.filter_by_type(params[:type]) if params[:type].present?

    sorted_results
  end

  private

    def enforce_nil_for_empty_version
      self.version = nil if version.try(:empty?)
    end
end

# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :string(255)
#
