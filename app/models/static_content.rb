# frozen_string_literal: true

class StaticContent < ApplicationRecord
  validates_presence_of :name, :data_type
  validates :name, uniqueness: { case_sensitive: false }

  scope :filter_by_type, ->(type) { where data_type: type }
  scope :ordered_by_name, ->(order) { order(name: order) }
  scope :ordered_by_id, ->(order) { order(id: order) }

  def self.for_params(params)
    static_contents = StaticContent.all

    if params[:type].present?
      static_contents = static_contents.filter_by_type(params[:type])
    end

    if params[:id].present?
      static_contents = static_contents.ordered_by_id(params[:id].to_sym)
    elsif params[:name].present?
      static_contents = static_contents.ordered_by_name(params[:name].to_sym)
    end

    static_contents
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
