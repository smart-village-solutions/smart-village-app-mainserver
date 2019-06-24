# frozen_string_literal: false

module Mutations
  class DestroyEventRecord < BaseMutation
    argument :id, Integer, required: true

    type Types::EventRecordType

    def resolve(id:)
      EventRecord.find(id).destroy
    end
  end
end