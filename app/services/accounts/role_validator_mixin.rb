# frozen_string_literal: true

module Accounts
  module RoleValidatorMixin
    extend ActiveSupport::Concern

    ALLOWED_ROLES = %w[user restricted].freeze

    def validate_role(role)
      return if allowed_role?(role)

      raise ArgumentError, "Role not allowed"
    end

    def allowed_role?(role)
      ALLOWED_ROLES.include?(role)
    end
  end
end
