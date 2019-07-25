# frozen_string_literal: true

class DataProvider < ApplicationRecord
  store :always_recreate, accessors: %i[point_of_interest tour news_item event_record], coder: JSON

  has_one :address, as: :addressable
  has_one :contact, as: :contactable
  has_one :logo, as: :web_urlable, class_name: "WebUrl"

  accepts_nested_attributes_for :address, :contact, :logo
end

# == Schema Information
#
# Table name: data_providers
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  description     :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  always_recreate :text(65535)
#
