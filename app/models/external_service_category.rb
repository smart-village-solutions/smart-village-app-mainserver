# frozen_string_literal: true

class ExternalServiceCategory < ApplicationRecord
  belongs_to :external_service
  belongs_to :category

  validates :external_id, uniqueness: { scope: :external_service_id, allow_blank: true }, if: -> { external_id.present? }
end

# == Schema Information
#
# Table name: external_service_categories
#
#  id                  :bigint           not null, primary key
#  external_id         :string(255)
#  external_service_id :bigint           not null
#  category_id         :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
