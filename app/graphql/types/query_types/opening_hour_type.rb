# frozen_string_literal: true

module Types
  class QueryTypes::OpeningHourType < Types::BaseObject
    field :id, ID, null: true
    field :weekday, String, null: true
    field :date_from, String, null: true
    field :date_to, String, null: true
    field :time_from, String, null: true
    field :time_to, String, null: true
    field :sort_number, Integer, null: true
    field :open, Boolean, null: true
    field :use_year, Boolean, null: true
    field :description, String, null: true

    def time_from
      return "" if object.time_from.blank?

      begin
        object.time_from.strftime("%H:%M")
      rescue StandardError
        ""
      end
    end

    def time_to
      return "" if object.time_to.blank?

      begin
        object.time_to.strftime("%H:%M")
      rescue StandardError
        ""
      end
    end

    def date_from
      return "" if object.date_from.blank?

      begin
        object.date_from.strftime("%Y-%m-%d")
      rescue StandardError
        ""
      end
    end

    def date_to
      return "" if object.date_to.blank?

      begin
        object.date_to.strftime("%Y-%m-%d")
      rescue StandardError
        ""
      end
    end
  end
end
