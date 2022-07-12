class AddIndexToMainserver < ActiveRecord::Migration[5.2]
  def change
    add_index :attractions, :name
    add_index :attractions, :data_provider_id
    add_index :attractions, :type
    add_index :attractions, :external_id
    add_index :data_resource_categories, [:data_resource_id, :data_resource_type], name: 'index_drc_on_dr_id_and_dr_type'
    add_index :data_resource_categories, :category_id
    add_index :addresses, [:addressable_id, :addressable_type], name: 'index_addresses_on_addressable_id_and_addressable_type'
    add_index :geo_locations, [:geo_locateable_id, :geo_locateable_type], name: 'index_geo_locations_on_locable_id_and_locaable_type'
    add_index :geo_locations, [:latitude, :longitude]
    add_index :static_contents, :name
    add_index :static_contents, :data_type
    add_index :static_contents, :version
    add_index :external_references, [:external_id, :external_type], name: 'index_external_references_on_id_and_type'
    add_index :data_resource_settings, [:data_provider_id, :data_resource_type], name: 'index_dr_settings_on_dr_id_and_dr_type'
    add_index :event_records, :data_provider_id
    add_index :generic_items, :data_provider_id
    add_index :news_items, :data_provider_id
    add_index :accessibility_informations, [:accessable_type, :accessable_id], name: 'index_accessibility_informations_on_type_and_id'
    add_index :addresses, [:addressable_type, :addressable_id], name: 'index_addresses_on_type_and_id'
    add_index :categories, :name
    add_index :contacts, [:contactable_type, :contactable_id], name: 'index_contacts_on_type_and_id'
    add_index :content_blocks, [:content_blockable_type, :content_blockable_id], name: 'index_content_blocks_on_type_and_id'
    add_index :fixed_dates, [:dateable_type, :dateable_id], name: 'index_fixed_dates_on_type_and_id'
    add_index :fixed_dates, :date_start
    add_index :fixed_dates, :date_end
    add_index :locations, [:locateable_type, :locateable_id], name: 'index_locations_on_type_and_id'
    add_index :locations, :name
    add_index :media_contents, [:mediaable_type, :mediaable_id], name: 'index_media_contents_on_type_and_id'
    add_index :web_urls, [:web_urlable_type, :web_urlable_id], name: 'index_web_urls_on_type_and_id'
  end
end
