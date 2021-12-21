# frozen_string_literal: true

class StaticContent < ApplicationRecord
  validates_presence_of :name, :data_type
  validates :name, uniqueness: { case_sensitive: false }

  scope :filter_by_type, ->(type) { where data_type: type }
  include Sortable.new :name, :id

  def self.sorted_and_filtered_for_params(params)
    if params[:type]
      self.sorted_for_params(params).filter_by_type(params[:type])
    else
      self.sorted_for_params(params)
    end
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
#
