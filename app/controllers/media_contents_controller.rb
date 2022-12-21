# frozen_string_literal: true

class MediaContentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :auth_user_or_doorkeeper

  # POST /media_contents.json
  def create
    media_content = MediaContent.new(media_content_params)

    respond_to do |format|
      if media_content.save
        format.json do
          render json: {
            media_content: media_content,
            service_url: media_content.attachment.service_url.sub(/\?.*/, "")
          }, status: :created
        end
      else
        format.json { render json: media_content.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def auth_user_or_doorkeeper
      raise "unauthorized" if current_user.present? && !current_user.admin_role?

      doorkeeper_authorize! if current_user.blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_content_params
      params.require(:media_content).permit(:attachment, :content_type)
    end

end
