module ApplicationHelper
  def render_selectable_categories(categories, form)
    category_tags = ""
    base_element = "user[data_provider_attributes][data_resource_settings_attributes][#{form.options[:child_index]}][default_category_ids][]"

    categories.each do |category, subtree|
      tree_element = check_box_tag(
        base_element,
        category.id,
        Array(form.object.default_category_ids).include?(category.id.to_s)
      )
      tree_element += category.name
      tree_element += render_selectable_categories(subtree, form)
      category_tags << content_tag("li", raw(tree_element))
    end

    content_tag("ul", raw(category_tags))
  end

  def render_categories(categories)
    category_tags = ""
    categories.each do |category, subtree|
      tree_element = []
      element_buttons = []

      tree_element << content_tag("span", "ID: #{category.id}", class: "badge badge-info")
      if category.icon_name.present?
        tree_element << content_tag("span", "Icon: #{category.icon_name}", class: "badge badge-secondary")
      end
      if category.contact.try(:email).present?
        tree_element << content_tag(
          "span",
          pluralize(category.contact.email.to_s.split(",").count, "E-Mail"),
          class: "badge badge-warning cursor-arrow",
          title: category.contact.email,
          style: "cursor: help;"
        )
      end
      tree_element << category.name
      tree_element << content_tag("span", category.tags.map(&:name).map { |tag_name| I18n.t("data_resource.#{tag_name}.other") }.join(", "), class: "badge badge-light")
      element_buttons << link_to("New Child", new_category_path(parent_id: category.id), class: "btn btn-xs btn-outline-success")
      element_buttons << link_to("Edit", edit_category_path(category), class: "btn btn-xs btn-outline-secondary")
      element_buttons << link_to("Destroy", category, method: :delete, data: { confirm: "Are you sure? All children are destroyed as well!" }, class: "btn btn-xs btn-outline-danger")
      tree_element << content_tag("div", raw(element_buttons.join), class: "action-links")
      tree_element << render_categories(subtree)
      tree_element = tree_element.join(" ")
      category_tags << content_tag("li", raw(tree_element))
    end
    content_tag("ul", raw(category_tags))
  end
end
