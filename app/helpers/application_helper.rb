module ApplicationHelper

  def render_selectable_categories(categories, form)
    category_tags = ""
    categories.each do |category, subtree|
      base_element = "user[data_provider_attributes][data_resource_settings_attributes][#{form.options[:child_index]}][default_category_ids][]"
      tree_element = check_box_tag base_element, category.id, Array(form.object.default_category_ids).include?(category.id.to_s)
      tree_element += category.name
      tree_element += render_selectable_categories(subtree, form)
      category_tags << content_tag("li", raw(tree_element) )
    end
    content_tag("ul", raw(category_tags))
  end

  def render_categories(categories)
    category_tags = ""
    categories.each do |category, subtree|
      tree_element = []
      tree_element << category.name
      tree_element << "(ID:#{category.id})"
      tree_element << link_to('New', new_category_path(parent_id: category.id))
      tree_element << link_to('Edit', edit_category_path(category))
      tree_element << link_to('Destroy', category, method: :delete, data: { confirm: 'Are you sure? All children are destroyed as well!' })
      tree_element << render_categories(subtree)
      tree_element = tree_element.join(" ")
      category_tags << content_tag("li", raw(tree_element) )
    end
    content_tag("ul", raw(category_tags))
  end
end
