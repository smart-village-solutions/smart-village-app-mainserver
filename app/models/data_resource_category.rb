# frozen_string_literal: true

class DataResourceCategory < ApplicationRecord
  belongs_to :category
  belongs_to :data_resource, polymorphic: true
end

# == Schema Information
#
# Table name: data_resource_categories
#
#  id                 :bigint           not null, primary key
#  data_resource_id   :integer
#  data_resource_type :string(255)
#  category_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
