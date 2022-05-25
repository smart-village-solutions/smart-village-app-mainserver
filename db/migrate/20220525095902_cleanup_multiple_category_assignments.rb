class CleanupMultipleCategoryAssignments < ActiveRecord::Migration[5.2]
  def up
    grouped_resource_categories = DataResourceCategory.all.group_by { |a| [a.category_id, a.data_resource_type, a.data_resource_id]}
    to_delete_ids = []
    grouped_resource_categories.each do |_group, resource_categories|
      next if resource_categories.count <= 1

      resource_category_ids = resource_categories.map(&:id)
      min_id = resource_category_ids.min
      to_delete_ids << resource_category_ids - Array(min_id)
    end
    DataResourceCategory.where(id: to_delete_ids.flatten).delete_all if to_delete_ids.flatten.any?
  end

  def down
  end
end
