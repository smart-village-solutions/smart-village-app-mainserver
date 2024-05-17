# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
end
