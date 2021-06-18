# frozen_string_literal: true

FactoryBot.define do
  factory :survey, class: "Survey::Poll" do
    title { { de: "Umfrage" }.to_json }
    description { { de: "Beschreibung" }.to_json }
    visible { true }
    data_provider_id { create(:data_provider).id }
  end
end
