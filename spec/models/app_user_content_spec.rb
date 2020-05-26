# frozen_string_literal: true

require "rails_helper"

RSpec.describe AppUserContent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: app_user_contents
#
#  id          :bigint           not null, primary key
#  content     :text(65535)
#  data_type   :string(255)
#  data_source :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
