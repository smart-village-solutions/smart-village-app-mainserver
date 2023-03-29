class GenericItem < ApplicationRecord
  include FilterByRole

  has_ancestry orphan_strategy: :destroy

  GENERIC_TYPES = {
    deadline: "Deadline",
    defect_report: "DefectReport",
    job: "Job",
    offer: "Offer",
    construction_site: "ConstructionSite",
    noticeboard: "Noticeboard"
  }.freeze

  attr_accessor :force_create
  attr_accessor :category_name
  attr_accessor :category_names

  before_save :remove_emojis
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
  has_many :generic_item_messages, class_name: "GenericItem::Message", dependent: :destroy
  has_many :push_notifications,
           as: :notification_pushable,
           class_name: "Notification::Push",
           dependent: :destroy

  # defined by FilterByRole
  # scope :visible, -> { where(visible: true) }

  scope :by_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  scope :by_location, lambda { |location_name|
    where(locations: { name: location_name }).or(where(addresses: { city: location_name }))
      .left_joins(:locations).left_joins(:addresses)
  }

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :content_blocks, :data_provider, :price_informations, :opening_hours,
                                :media_contents, :accessibility_informations, :addresses, :contacts,
                                :companies, :locations, :dates, :push_notifications

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

  def perform_callbacks
    noticeboard_notify_creator if noticeboard?
    defect_report_notify_for_category if defect_report?
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

    def noticeboard?
      generic_type == GENERIC_TYPES[:noticeboard]
    end

    # send an email to the creator if generic type is "Noticeboard"
    def noticeboard_notify_creator
      NoticeboardMailer.notify_creator(self).deliver_later
    end

    def defect_report?
      generic_type == GENERIC_TYPES[:defect_report]
    end

    # send an email to addresses based on category if generic type is "DefectReport"
    def defect_report_notify_for_category
      DefectReportMailer.notify_for_category(self).deliver_later
    end

    def remove_emojis
      self.title = RemoveEmoji::Sanitize.call(title) if title.present?
      self.description = RemoveEmoji::Sanitize.call(description) if description.present?
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
