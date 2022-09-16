class AddImportfeedsToDataProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :data_providers, :import_feeds, :text, limit: 12.megabytes
  end
end
