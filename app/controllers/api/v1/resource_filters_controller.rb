# frozen_string_literal: true

module Api
  module V1
    class ResourceFiltersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!, only: %i[create]
      before_action :authenticate_user_role, only: %i[create]

      def authenticate_user_role
        render inline: "not allowed", status: 404 unless current_user.admin_role?
      end

      # POST /api/v1/resource_filters
      #
      # Speichert die ausgewählten Filteroptionen für ein bestimmtes Datenmodell.
      #
      # @param [String] resource_type - Der Name des Datenmodells (z.B. "PointOfInterest")
      # @param [Hash] filters - Die ausgewählten Filteroptionen mit zusätzlichen Attributen
      #
      # @example Anfrage-Body
      #   {
      #     "resource_type": "PointOfInterest",
      #     "filters": {
      #       "category": { "max_selection": 4 },
      #       "location": { "radius": 10 }
      #     }
      #   }
      #
      # @return [JSON] Erfolgsnachricht oder Fehlerdetails
      def create
        resource_filter = @current_municipality.data_resource_filters.find_or_initialize_by(data_resource_type: filter_params[:resource_type])
        filters = filter_params[:filters]
        begin
          filters = filters.is_a?(String) && filters.present? ? JSON.parse(filters) : filters
        rescue StandardError => e
          respond_to do |format|
            format.json do
              render json: { errors: ["Ungültiges JSON-Format für Filter: #{e}"] },
                     status: :unprocessable_entity and return
            end
            format.js { render js: "alert('Ungültiges JSON-Format für Filter');" and return }
          end
        end

        resource_filter.config = filters

        if resource_filter.save
          respond_to do |format|
            format.json { render json: { success: true, message: "Filter erfolgreich gespeichert." }, status: :ok }
            format.js { render js: "alert('Filter erfolgreich gespeichert.');" }
          end
        else
          respond_to do |format|
            format.json { render json: { errors: resource_filter.errors.full_messages }, status: :unprocessable_entity }
            format.js { render js: "alert('#{resource_filter.errors.full_messages}');" }
          end
        end
      end

      def filter_params
        params.permit!
      end
    end
  end
end
