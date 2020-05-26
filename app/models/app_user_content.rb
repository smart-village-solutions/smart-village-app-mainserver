# frozen_string_literal: true

class AppUserContent < ApplicationRecord
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
