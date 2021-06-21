# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateOrUpdateSurveyPoll do
  def perform(**args)
    Mutations::CreateOrUpdateSurveyPoll.new(object: nil, context: {}).resolve(args)
  end

  describe "creation of a survey poll with german data" do
    let(:survey_poll) do
      perform(
        title: { de: "asd" },
        description: { de: "lorem ipsum dolor saner" },
        question_title: { de: "1" },
        response_options: [{ title: { de: "111asd" } }, { title: { de: "222asd" } }],
        date_attributes: { date_start: "2021-06-10", date_end: "2021-07-20" },

        # copied from other specs:
        data_provider_attributes: { name: "Bäder Betrieb Brandenburg", address_attributes: { addition: "Schwimmbad 2", street: "Strandstraße", zip: "10100", city: "Bad Belzig", geo_location_attributes: { latitude: 8_123_345.3726, longitude: 8_723_647.9347 } }, contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, logo_attributes: { url: "https://www.logo-url.de", description: "url that lkeads to a logo image file" }, description: "TMB dind die besten" }
      )
    end

    it "creates a new and valid survey poll" do
      expect(survey_poll).to be_a(Survey::Poll)
      expect(survey_poll).to be_valid
    end

    it "has a german title" do
      expect(survey_poll.title[:de]).to eq("asd")
    end

    it "has a german description" do
      expect(survey_poll.description[:de]).to eq("lorem ipsum dolor saner")
    end

    it "has a german question title" do
      expect(survey_poll.question_title[:de]).to eq("1")
    end

    it "has two response options" do
      expect(survey_poll.response_options.count).to eq(2)
    end

    it "has a start day and end year" do
      expect(survey_poll.date.date_start.day).to eq(10)
      expect(survey_poll.date.date_end.year).to eq(2021)
    end
  end
end
