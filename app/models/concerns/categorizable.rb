# frozen_string_literal: false

module Categorizable
  extend ActiveSupport::Concern

  # für Abwärtskompatibilität, wenn nur ein einiger Kategorienamen angegeben wird
  # ist der attr_accessor :category_name befüllt:
  # category_name = "foobar"
  # und wenn mehrere Kategorien auf einmal gesetzt werden, ist der attr_accessor :category_names befüllt:
  # category_names = [{name: "foo"}, {name: "bar"}]
  # attr_accessor category_name oder category_names findet sich in Modellen, in denen dieses Modul aktiviert ist
  def find_or_create_category # rubocop:disable Metrics/AbcSize
    category_names_to_add = Array(category_names).map { |a| a.fetch(:name, nil) } + Array(category_name)
    category_names_to_add = category_names_to_add.compact.uniq.reject(&:blank?)

    existing_categories = Category.where(name: category_names_to_add)
    existing_categories_by_name = existing_categories.index_by(&:name) # Map them by name for easy lookup

    category_names_to_add.each do |name|
      category = existing_categories_by_name[name] || Category.create!(name: name)
      categories << category unless categories.include?(category)
    end
  end
end
