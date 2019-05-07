# frozen_string_literal: true

#
# Attraction is the superclass for all (touristic) attractions in the smart village.
#
class Attraction < ApplicationRecord
  belongs_to :category
  has_many :adresses, as: :adressable
  has_many :contacts, as: :contactable
  has_many :media_contents, as: :mediaable
  has_one :operating_company, as: :companyable
  has_one :data_provider, as: :provideable
  has_many :web_urls, as: :web_urlable

  validates_presence_of :name
  acts_as_taggable
end

# == Schema Information
#
# Table name: attractions
#
#  id                 :bigint           not null, primary key
#  external_id        :integer
#  name               :string(255)
#  description        :string(255)
#  mobile_description :string(255)
#  active             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
