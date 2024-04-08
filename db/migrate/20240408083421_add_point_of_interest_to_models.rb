# frozen_string_literal: true

class AddPointOfInterestToModels < ActiveRecord::Migration[6.1]
  def change
    add_column :news_items, :point_of_interest_id, :integer
    add_column :event_records, :point_of_interest_id, :integer
  end
end
