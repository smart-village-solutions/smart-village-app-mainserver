class GenericItem < ApplicationRecord
  include FilterByRole
  has_ancestry orphan_strategy: :destroy

  validates_presence_of :generic_type
  store :payload, coder: JSON

  belongs_to :data_provider
  has_one :external_reference, as: :external, dependent: :destroy
  has_many :accessibility_informations, as: :accessable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :data_resource_categories, as: :data_resource
  has_many :categories, through: :data_resource_categories
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :companies, as: :companyable, dependent: :destroy
  has_many :content_blocks, as: :content_blockable, dependent: :destroy
  has_many :web_urls, as: :web_urlable, dependent: :destroy
  has_many :opening_hours, as: :openingable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_many :media_contents, as: :mediaable, dependent: :destroy
  has_many :locations, as: :locateable, dependent: :destroy

  scope :with_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :content_blocks, :data_provider, :price_informations, :opening_hours,
                                :media_contents, :accessibility_informations, :addresses, :contacts,
                                :companies, :locations

  def unique_id
    return external_id if external_id.present?

    fields = [title, published_at]

    generate_checksum(fields)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "GenericItem").first.try(:settings)
  end
end
