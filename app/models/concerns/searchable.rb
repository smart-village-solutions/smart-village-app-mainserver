# frozen_string_literal: true

# Provide simple searching (per field) capability on model
# TODO: Maybe add functionality to search on multiple fields at once
module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    # Example:
    # class Model < ActiveRecord::Base
    #   include Searchable
    #   searchable_on :email, :name
    # end
    #
    # Generates:
    # Model.where_email_contains(query)
    # Model.where_name_contains(query)
    def searchable_on(*search_columns)
      search_columns.each do |search_column|
        method_name = "where_#{search_column}_contains".to_sym

        define_singleton_method(method_name) do |search_query|
          if search_query.present?
            where("#{search_column} LIKE '%#{search_query}%'")
          else
            all
          end
        end
      end
    end
  end
end
