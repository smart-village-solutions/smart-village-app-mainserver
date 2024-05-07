# frozen_string_literal: true

class AddVisibilityToQuotas < ActiveRecord::Migration[6.1]
  def change
    add_column :quotas, :visibility, :integer, default: 0
  end
end
