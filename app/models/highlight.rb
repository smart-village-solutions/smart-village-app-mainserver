class Highlight < ApplicationRecord
  belongs_to :highlightable, polymorphic: true
end
