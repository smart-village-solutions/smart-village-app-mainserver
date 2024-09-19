# frozen_string_literal: true

class Filters::AttributeService
  # {
  #   allowed_attributes: [:radius],
  #   attribute_validations: {
  #     radius: { type: Numeric, allow_nil: true }
  #   }
  # }
  def date_start
    {
      default: nil,
      allowed_attributes: %i[past_dates future_dates],
      attribute_validations: {
        past_dates: { type: Boolean, allow_nil: true, default: false },
        future_dates: { type: Boolean, allow_nil: true, default: true }
      }
    }
  end

  def date_end
    {
      default: nil,
      allowed_attributes: %i[past_dates future_dates],
      attribute_validations: {
        past_dates: { type: Boolean, allow_nil: true, default: false },
        future_dates: { type: Boolean, allow_nil: true, default: true }
      }
    }
  end

  def category
    {
      allowed_attributes: [:multiselect],
      default: nil,
      attribute_validations: {
        multiselect: { type: Boolean, allow_nil: true, default: true }
      }
    }
  end

  def location
    {
      default: nil,
      allowed_attributes: [:multiselect],
      attribute_validations: {
        multiselect: { type: Boolean, allow_nil: true, default: false }
      }
    }
  end

  def saveable
    {
      default: true
    }
  end
end
