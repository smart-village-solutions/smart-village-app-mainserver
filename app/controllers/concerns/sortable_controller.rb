# Controller Concern for Controllers that use models,
# which include the 'Sortable' concern
# Provides a helper for views to generate the sorting links
module SortableController
  extend ActiveSupport::Concern

  def params_for_link(sort_column=nil)
    Sortable.params_for_link(request.query_parameters.dup, sort_column)
  end

  included do
    helper_method :params_for_link
  end
end
