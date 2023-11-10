# frozen_string_literal: true

module Types
  class QueryTypes::DateType < Types::BaseObject
    field :id, ID, null: true
    field :weekday, String, null: true
    field :date_start, String, null: true
    field :date_end, String, null: true
    field :time_start, String, null: true
    field :time_end, String, null: true
    field :time_description, String, null: true
    field :use_only_time_description, String, null: true

    def time_start
      return "" if object.time_start.blank?

      begin
        object.time_start.strftime("%H:%M")
      rescue
        ""
      end
    end

    def time_end
      return "" if object.time_end.blank?

      begin
        object.time_end.strftime("%H:%M")
      rescue
        ""
      end
    end

    def date_start
      return "" if object.date_start.blank?

      begin
        object.date_start.strftime("%Y-%m-%d")
      rescue
        ""
      end
    end

    def date_end
      return "" if object.date_end.blank?

      begin
        object.date_end.strftime("%Y-%m-%d")
      rescue
        ""
      end
    end

  end
end
