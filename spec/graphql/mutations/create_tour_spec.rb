# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::Tour do
  def perform(**args)
    Mutations::CreateTour.new(object: nil, context: {}).resolve(args)
  end

  def create_regions
    10.times do
      Region.create(name: Faker::Address.country)
    end
  end

  def create_categories
    cat_1 = Category.create(name: Faker::IndustrySegments.super_sector)
    cat_2 = Category.create(name: Faker::IndustrySegments.sector, parent: cat_1)
    Category.create(name: Faker::IndustrySegments.sub_sector, parent: cat_2)
  end

  it "creates a new and valid Tour" do
    create_categories
    create_regions
    tour = perform(
      name: "test", description: "Lorem ipsum dolor sit amet consectetur adipiscing", active: true, category_id: Category.last.id, addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 832_764.37264, longitude: 8_723_647.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, data_provider_attributes: { name: "Bäder Betrieb Brandenburg", address_attributes: { addition: "Schwimmbad 2", street: "Strandstraße", zip: "10100", city: "Bad Belzig", geo_location_attributes: { latitude: 8_123_345.3726, longitude: 8_723_647.9347 } }, contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, logo_attributes: { url: "https://www.logo-url.de", description: "url that lkeads to a logo image file" }, description: "TMB dind die besten" }, operating_company_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: -7.45018, longitude: -102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, web_urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], length_km: 234, means_of_transportation: "bike", geometry_tour_data_attributes: [{ latitude: 83.37264, longitude: 23.431234 }, { latitude: 83.37264, longitude: 23.431234 }, { latitude: 43.37264, longitude: 63.431234 }], tag_list: "[swim, swam, swum]"
    )
    expect(tour).to be_a(Tour)
    expect(tour).to be_valid
  end
end
