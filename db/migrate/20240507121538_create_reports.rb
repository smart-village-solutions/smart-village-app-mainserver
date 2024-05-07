class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true, index: true, null: false
      t.timestamps
    end
  end
end
