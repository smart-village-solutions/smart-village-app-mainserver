# frozen_string_literal: true

# This model organizes different categories as a category tree with the help of the ancestry
# gem.
class Category < ApplicationRecord
  has_ancestry
end

# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  tmb_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
