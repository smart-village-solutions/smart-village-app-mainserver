# frozen_string_literal: true

module Mutations
  class CreateCategories < BaseMutation
    description "Creates one or more categories with optional subcategories"

    field :categories, [Types::QueryTypes::CategoryType], null: false
    field :errors, [String], null: false

    # Argumente der Mutation
    argument :categories, [Types::InputTypes::CategoryInput], required: true

    def resolve(categories:)
      created_categories = []
      errors = []

      ActiveRecord::Base.transaction do
        categories.each do |category_attributes|
          category = create_category_with_children(category_attributes.to_h)
          created_categories << category
        rescue ActiveRecord::RecordInvalid => e
          errors << e.record.errors.full_messages
          raise ActiveRecord::Rollback
        end
      end

      {
        categories: created_categories,
        errors: errors.flatten
      }
    end

    private

      def create_category_with_children(attributes, parent = nil)
        # Extract children, if present
        children = attributes.delete(:children)

        category = Category.where(attributes).first_or_initialize
        if category.new_record?
          category.parent = parent if parent
          category.save!
        end

        # Recursively create subcategories
        if children.present?
          children.each do |child_attributes|
            create_category_with_children(child_attributes, category)
          end
        end

        category
      end
  end
end
