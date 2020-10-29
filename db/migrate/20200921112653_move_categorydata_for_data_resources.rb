class MoveCategorydataForDataResources < ActiveRecord::Migration[5.2]
  def up
    [EventRecord, Tour, PointOfInterest].each do |record_class|
      record_class.all.each do |record|
        DataResourceCategory.where(
          category_id: record.attributes["category_id"],
          data_resource_type: record_class.to_s,
          data_resource_id: record.id
        ).first_or_create
      end
    end
  end

  def down
  end
end
