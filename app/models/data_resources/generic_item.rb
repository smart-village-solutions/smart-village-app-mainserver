class GenericItem < ApplicationRecord
  include FilterByRole
  has_ancestry orphan_strategy: :destroy

  attr_accessor :force_create
  attr_accessor :category_name
  attr_accessor :category_names

  after_save :find_or_create_category

  validates_presence_of :generic_type
  store :payload, coder: JSON

  belongs_to :data_provider
  has_one :external_reference, as: :external, dependent: :destroy
  has_many :accessibility_informations, as: :accessable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :data_resource_categories, as: :data_resource
  has_many :categories, through: :data_resource_categories
  has_many :companies, as: :companyable, class_name: "OperatingCompany", dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :content_blocks, as: :content_blockable, dependent: :destroy
  has_many :dates, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_many :locations, as: :locateable, dependent: :destroy
  has_many :media_contents, as: :mediaable, dependent: :destroy
  has_many :opening_hours, as: :openingable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_many :web_urls, as: :web_urlable, dependent: :destroy

  # defined by FilterByRole
  # scope :visible, -> { where(visible: true) }

  scope :by_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :content_blocks, :data_provider, :price_informations, :opening_hours,
                                :media_contents, :accessibility_informations, :addresses, :contacts,
                                :companies, :locations, :dates
  def generic_items
    children
  end

  def unique_id
    return external_id if external_id.present?

    fields = [title, published_at]

    generate_checksum(fields)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "GenericItem").first.try(:settings)
  end

  def content_for_facebook
    {
      message: [title, teaser, description].delete_if(&:blank?).compact.join("\n\n"),
      link: ""
    }
  end

  private

    def find_or_create_category
      # für Abwärtskompatibilität, wenn nur ein einiger Kategorienamen angegeben wird
      # ist der attr_accessor :category_name befüllt
      if category_name.present?
        category_to_add = Category.where(name: category_name).first_or_create
        categories << category_to_add unless categories.include?(category_to_add)
      end

      # Wenn mehrere Kategorien auf einmal gesetzt werden
      # ist der attr_accessor :category_names befüllt
      if category_names.present?
        category_names.each do |category|
          next unless category[:name].present?
          category_to_add = Category.where(name: category[:name]).first_or_create
          categories << category_to_add unless categories.include?(category_to_add)
        end
      end
    end

end

# == Schema Information
#
# Table name: generic_items
#
#  id               :bigint           not null, primary key
#  generic_type     :string(255)
#  author           :text(65535)
#  publication_date :datetime
#  published_at     :datetime
#  external_id      :text(65535)
#  visible          :boolean          default(TRUE)
#  title            :text(65535)
#  teaser           :text(65535)
#  description      :text(65535)
#  data_provider_id :integer
#  payload          :text(65535)
#  ancestry         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
