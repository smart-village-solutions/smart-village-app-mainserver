# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateEventRecord do
  def perform(**args)
    Mutations::CreateEventRecord.new(object: nil, context: {}).resolve(args)
  end

  def create_categories
    category_1 = Category.create(name: Faker::IndustrySegments.super_sector)
    category_2 = Category.create(name: Faker::IndustrySegments.sector, parent: category_1)
    Category.create(name: Faker::IndustrySegments.sub_sector, parent: category_2)
  end

  it "creates a new and valid Point of interest" do
    create_categories
    event_record = perform(
      parent_id: 1, description: "Lorem ipsum dolor sit amet consectetur adipiscing", title: "Test", dates_attributes: [{ weekday: "Monday", time_start: "16:00", time_end: "18:00", time_description: "das Training findet jeden zweiten Montag im Monat statt", use_only_time_description: false }], repeat: true, repeat_duration_attributes: { start_date: "0001-12-18", end_date: "0021-07-19", every_year: true }, category_id: 5, region_id: 3, addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 64.37264, longitude: 47.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], data_provider_attributes: { name: "Bäder Betrieb Brandenburg", address_attributes: { addition: "Schwimmbad 2", street: "Strandstraße", zip: "10100", city: "Bad Belzig", geo_location_attributes: { latitude: 8_123_345.3726, longitude: 8_723_647.9347 } }, contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, logo_attributes: { url: "https://www.logo-url.de", description: "url that lkeads to a logo image file" }, description: "TMB dind die besten" }, contacts_attributes: [{ first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }], urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], organizer_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: 7.45018, longitude: 102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, price_informations_attributes: [{ name: "Standardkarte", amount: 5.89, group_price: false, description: "Tarif gilt nicht in den Ferien" }, { name: "Familienkarte", amount: 18.0, group_price: true, age_from: 2, age_to: 17, min_adult_count: 10, max_adult_count: 17, min_children_count: 3, max_children_count: 9, description: "Tarif gilt nur in den Ferien." }], accessibility_information_attributes: { description: "bla", types: "Tops", urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }] }, tag_list: ["megaparty", "technoclassix", "underground"]
    )
    expect(event_record).to be_a(EventRecord)
    expect(event_record).to be_valid
  end
end
