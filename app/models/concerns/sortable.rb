# The code in here is a bit complicated.
# I wanted to be able to use include with arguments.
# Read this blogpost: https://cutt.ly/jUr8M8f
class Sortable < Module

  #
  # *fields are the fields which can be sorted
  # 
  def initialize(*fields)
    # super() with brackets calls super with no arguments.
    # Otherwise the would get passed and would throw an error
    super() do

      # Create an anonymous Module and store it in a local variable
      # It will contain all the class methods which are later appended
      # to the ActiveRecord Model.
      #
      # For example:
      # class Model < ActiveRecord::Base
      #   include Sortable.new :name, :email
      # end
      #
      # Would lead to:
      # Model.sorted_by_name(order)
      # Model.sorted_by_email(order)
      singleton_methods = Module.new do
        fields.each do |field|
          method_name = "sorted_by_#{field}".to_sym
          define_method(method_name) do |order|
            p = Hash.new
            p[field] = order
            order(p)
          end

        end

        define_method(:sorted_fields) do
          fields
        end

        # This class methods returns all records sorted for the specified
        # column and specified order
        #
        # If column is not given or invalid, it returns all records
        define_method(:sorted_for_params) do |params|
          if params[:sort_column].present? && params[:sort_order].present?
            if self.sorted_fields.include?(params[:sort_column].to_sym)
              method_name = "sorted_by_#{params[:sort_column]}".to_sym
              return self.send(method_name, params[:sort_order])
            end
          end

          self.all
        end
      end
      
      # We can't just use 'def self.included' here, because we
      # need accesss to the local variable
      define_singleton_method :included do |base|
        base.extend singleton_methods
      end
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
