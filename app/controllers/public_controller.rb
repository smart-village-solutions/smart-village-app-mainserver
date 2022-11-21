# frozen_string_literal: true

class PublicController < ActionController::Base
  layout "public"

  def generate_204
    head(:no_content)
  end
end
