module Sortable
  extend ActiveSupport::Concern

  class SortColumnsNotProvidedError < StandardError
    def initialize()
      super("You need to call #sortable_on in the Model using this concern.")
    end
  end

  included do
    attr_reader :sort_columns
  end

  module ClassMethods

    # Example:
    # class Model < ActiveRecord::Base
    #   include Sortable
    #   sortable_on :id, :email
    # end
    #
    # Generates:
    # Model.sorted_by_id(order)
    # Model.sorted_by_email(order)
    def sortable_on(*sort_columns)
      sort_columns.each do |sort_column|
        method_name = "sorted_by_#{sort_column}".to_sym

        define_singleton_method(method_name) do |sort_order|
          parameters = Hash.new
          parameters[sort_column] = sort_order
          self.order(parameters)
        end
      end

      @sort_columns = sort_columns
    end

    def sorted_for_params(params)
      raise SortColumnsNotProvidedError.new if @sort_columns.nil?

      if params[:sort_column].present? && params[:sort_order].present?
        if @sort_columns.include?(params[:sort_column].to_sym)
          method_name = "sorted_by_#{params[:sort_column]}".to_sym
          return self.send(method_name, params[:sort_order])
        end
      end

      self.all
    end
  end

  def self.params_for_link(params, sort_column=nil)
    return params if sort_column.nil?

    sort_order = params[:sort_order] == 'asc' ? 'desc' : 'asc'

    params.merge({
      sort_column: sort_column,
      sort_order: sort_order
    })
  end

end
