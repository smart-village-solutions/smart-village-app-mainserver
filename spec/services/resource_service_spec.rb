# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceService, type: :service do
  let(:maz) { create(:data_provider, name: "MAZ", news_item: true) }
  let(:tmb) { create(:data_provider, name: "TMB") }
  let(:news_item_1) { ResourceService.new(data_provider: maz).perform(NewsItem, params_maz) }
  let(:news_item_2) { ResourceService.new(data_provider: maz).perform(NewsItem, params_maz) }
  let(:poi_1) { ResourceService.new(data_provider: tmb).perform(PointOfInterest, params_tmb_poi) }
  let(:poi_1_changed) { ResourceService.new(data_provider: tmb).perform(PointOfInterest, params_tmb_poi_changed) }
  let(:poi_2) { ResourceService.new(data_provider: tmb).perform(PointOfInterest, params_tmb_poi) }
  let(:tour_1) { ResourceService.new(data_provider: tmb).perform(Tour, params_tmb_tour) }
  let(:tour_1_changed) { ResourceService.new(data_provider: tmb).perform(Tour, params_tmb_tour_changed) }
  let(:tour_2) { ResourceService.new(data_provider: tmb).perform(Tour, params_tmb_tour) }
  let(:event_1) { ResourceService.new(data_provider: tmb).perform(EventRecord, params_tmb_event) }
  let(:event_1_changed) { ResourceService.new(data_provider: tmb).perform(EventRecord, params_tmb_event_changed) }
  let(:event_2) { ResourceService.new(data_provider: tmb).perform(EventRecord, params_tmb_event) }

  def params_maz
    { author: "Robert sdf",
      external_id: 76_594,
      full_version: true,
      characters_to_be_shown: 10_000,
      news_type: "story",
      publication_date: "057",
      published_at: "07.07.2",
      source_url_attributes: { url: "http://www.ews.de", description: "source url of original article" },
      address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default",
                            geo_location_attributes: { latitude: 7.45018, longitude: 102.279 } },
      content_blocks_attributes: [{
        title: "Lorem sit amet consectetur adipiscing",
        intro: "Lorem ante ultriceatm torquent sit volutpat. Eros malesuada pretium sociosqu magnis mauris parturennaeos suspendisse tincidunt conu.",
        body: "Lorem ipsum dolor sit amet consectetaiicn,lttnciunt iaculis praesent ut. Nunc  hendrerit turpis himenaeos vestibulum sapien ae nostra erat lacus duis phasellus habitant, facilisis pretium iaculis commodo vivamus platea et eleifend tempor convallis tristique, lobortis cursus dapibus sem aenean mauris ac sagittis laoreet parturient senectus. Tortor eros curabitur congue ipsum vulputate dapibus montes tristique, accumsan hendrerit placerat praesent imperdiet laoreet mauris, luctus et turpis lacinia metus torquent lobortis.Interdum diam viverra libero hendrerit mauris adipiscing in odio faucibus, curae massa fusce nisi sed id tempor pulvinar, sit ante metus habitasse molestie fames nascetur rhoncus. Cum erat torquent tristique quis volutpat vulputate dui euismod sit integer, tincidunt iaculis non laoreet amet elementum nullam nascetur phasellus, potenti lacinia ultrices mauris vel habitant hac ligula feugiat pharetra, cras aptent leo lectus massa turpis tortor risus. Bt magnis sollicitudin. Conubia faucibus est nec felis ornare inceptos purus, integer proin dis at tempor class porta commodo, donec auctor ad mollis bibendum curae. Consequat bibendum turpis sem duis accumsan pharetra, tristique potenti pretium integer nec, lacus placerat quam sodales sit. Rhoncus cras mus penatibus sed lacinia eget consectetur fusce class tincidunt, condimentum iaculis eu fames hendrerit metus feugiat vehicula per, elementum bibendum nam pretium vitae pulvinar ridiculus a lacus.",
        media_contents_attributes: [
          { caption_text: "Lorem ipsum dolor sit amet consectetur adipiscing",
            copyright: "Lorem Merol",
            height: 7865,
            width: 346,
            content_type: "image" }
        ]
      }] }
  end

  def params_tmb_poi
    { name: "test",
      description: "Lorem ipsum dolor sit amet consectetur adipiscing",
      active: true,
      category_name: "Burgen",
      addresses_attributes: [
        { addition: "Bahnhof",
          street: "Musterstraße",
          zip: "10100",
          city: "Berlin",
          geo_location_attributes: {
            latitude: 832_764.37264, longitude: 8_723_647.9347
          } },
        { addition: "Bahnhof 2",
          street: "Musterstraße2",
          zip: "10100",
          city: "Berlin2" }
      ],
      contact_attributes: {
        first_name: "Tim",
        last_name: "Test",
        phone: "012345678",
        fax: "09843729047",
        web_urls_attributes: [
          { url: "http://www.test1.de", description: "url 1" },
          { url: "http://www.test2.de", description: "url 2" }
        ],
        email: "test@test.de"
      },
      price_informations_attributes: [
        { name: "Standardkarte", amount: 5.89, group_price: false, description: "Tarif gilt nicht in den Ferien" },
        { name: "Familienkarte", amount: 18.0, group_price: true, age_from: 2, age_to: 17, min_adult_count: 10, max_adult_count: 17, min_children_count: 3, max_children_count: 9, description: "Tarif gilt nur in den Ferien." }
      ],
      opening_hours_attributes: [
        {
          weekday: "Friday",
          date_from: "19-08-18",
          date_to: "25-03-20",
          time_from: "08:44:00 UTC",
          time_to: "00:02:00 UTC",
          sort_number: 1,
          open: true,
          description: "Ut id veritatis nihil."
        }
      ],
      operating_company_attributes: {
        name: "McClure, Kemmer and Brown",
        address_attributes: {
          street: "Abbie Manors",
          zip: "25083",
          city: "Mialand",
          kind: "default",
          geo_location_attributes: { latitude: -7.45018, longitude: -102.279 }
        },
        contact_attributes: {
          first_name: "Alonzo",
          last_name: "Von",
          phone: "+235 782-754-0007 x80976",
          web_urls_attributes: [
            {
              url: "http://ebert.biz/teri.beahan",
              description: "Temporibus autem qui at."
            }
          ]
        }
      },
      web_urls_attributes: [
        { url: "http://www.hoher-flaeming-naturpark.de",
          description: "Naturpark Hoher Fläming" },
        { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }
      ],
      media_contents_attributes: [
        {
          caption_text: "Qui dolore fugit rem.",
          copyright: "Zane Marquardt",
          height: 342,
          width: 215,
          content_type: "image",
          source_url_attributes: {
            url: "https://www.image.file",
            description: "main image"
          }
        }, {
          caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video"
        }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }
      ], location_attributes: { name: "Raben", department: "Niemegk", district: "Potsdam-Mittelmark", region_name: "Flaeming", state: "Brandenburg", geo_location_attributes: { latitude: 52.042051020544, longitude: 12.577602953518 } }, certificates_attributes: [{ name: "Qualitätssiegel Premium Schwimmbäder" }, { name: "Qualitätssiegel besondere Burg" }], accessibility_information_attributes: { description: "bla", types: "Tops", urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }] }, tag_list: ["[swim, swam, swum]"] }
  end

  def params_tmb_poi_changed
    { name: "test", description: "r sit amet consectetur adipiscing", active: true, category_name: "Burgen", addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", geo_location_attributes: { latitude: 832_764.37264, longitude: 8_723_647.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2" }], contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, price_informations_attributes: [{ name: "Standardkarte", amount: 5.89, group_price: false, description: "Tarif gilt nicht in den Ferien" }, { name: "Familienkarte", amount: 18.0, group_price: true, age_from: 2, age_to: 17, min_adult_count: 10, max_adult_count: 17, min_children_count: 3, max_children_count: 9, description: "Tarif gilt nur in den Ferien." }], opening_hours_attributes: [{ weekday: "Friday", date_from: "19-08-18", date_to: "25-03-20", time_from: "08:44:00 UTC", time_to: "00:02:00 UTC", sort_number: 1, open: true, description: "Ut id veritatis nihil." }], operating_company_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: -7.45018, longitude: -102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, web_urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], location_attributes: { name: "Raben", department: "Niemegk", district: "Potsdam-Mittelmark", region_name: "Flaeming", state: "Brandenburg", geo_location_attributes: { latitude: 52.042051020544, longitude: 12.577602953518 } }, certificates_attributes: [{ name: "Qualitätssiegel Premium Schwimmbäder" }, { name: "Qualitätssiegel besondere Burg" }], accessibility_information_attributes: { description: "bla", types: "Tops", urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }] }, tag_list: ["[swim, swam, swum]"] }
  end

  def params_tmb_tour
    { name: "Wandern durch Berlin", description: "description", active: true, category_name: "Wandertour", addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 64.37264, longitude: 47.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, operating_company_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: -7.45018, longitude: -102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, web_urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Natuacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], length_km: 500, means_of_transportation: "bike", geometry_tour_data_attributes: [{ latitude: 64.37264, longitude: 45.431234 }, { latitude: 32.37264, longitude: 40.431234 }, { latitude: 36.37264, longitude: 49.431234 }, { latitude: 39.37264, longitude: 41.431234 }, { latitude: 41.37264, longitude: 43.431234 }], tag_list: ["[swim, swam, swum]"] }
  end

  def params_tmb_tour_changed
    { name: "Wandern durch Berlin", description: "description changed", active: true, category_name: "Wandertour", addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 64.37264, longitude: 47.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], contact_attributes: { first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }, operating_company_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: -7.45018, longitude: -102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, web_urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Natuacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], length_km: 500, means_of_transportation: "bike", geometry_tour_data_attributes: [{ latitude: 64.37264, longitude: 45.431234 }, { latitude: 32.37264, longitude: 40.431234 }, { latitude: 36.37264, longitude: 49.431234 }, { latitude: 39.37264, longitude: 41.431234 }, { latitude: 41.37264, longitude: 43.431234 }], tag_list: ["[swim, swam, swum]"] }
  end

  def params_tmb_event
    { parent_id: 1, description: "Lorem ipsum dolor sit  consectetur adipiscing", title: "Test", dates_attributes: [{ weekday: "Monday", time_start: "16:00", time_end: "18:00", time_description: "das Training findet jeden zweiten Montag im Monat statt", use_only_time_description: false }], repeat: true, repeat_duration_attributes: { start_date: "0001-12-18", end_date: "0021-07-19", every_year: true }, category_name: "category name", region_name: "Flaeming", addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 64.37264, longitude: 47.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], contacts_attributes: [{ first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }], urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], organizer_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: 7.45018, longitude: 102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, price_informations_attributes: [{ name: "Standardkarte", amount: 5.89, group_price: false, description: "Tarif gilt nicht in den Ferien" }, { name: "Familienkarte", amount: 18.0, group_price: true, age_from: 2, age_to: 17, min_adult_count: 10, max_adult_count: 17, min_children_count: 3, max_children_count: 9, description: "Tarif gilt nur in den Ferien." }], accessibility_information_attributes: { description: "bla", types: "Tops", urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }] }, tag_list: ["megaparty", "technoclassix", "underground"] }
  end

  def params_tmb_event_changed
    { parent_id: 1, description: "Changed Lorem ipsum dolor sit  consectetur adipiscing", title: "Test", dates_attributes: [{ weekday: "Monday", time_start: "16:00", time_end: "18:00", time_description: "das Training findet jeden zweiten Montag im Monat statt", use_only_time_description: false }], repeat: true, repeat_duration_attributes: { start_date: "0001-12-18", end_date: "0021-07-19", every_year: true }, category_name: "category name", region_name: "Flaeming", addresses_attributes: [{ addition: "Bahnhof", street: "Musterstraße", zip: "10100", city: "Berlin", kind: "start", geo_location_attributes: { latitude: 64.37264, longitude: 47.9347 } }, { addition: "Bahnhof 2", street: "Musterstraße2", zip: "10100", city: "Berlin2", kind: "end" }], contacts_attributes: [{ first_name: "Tim", last_name: "Test", phone: "012345678", fax: "09843729047", web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }], email: "test@test.de" }], urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }, { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }], media_contents_attributes: [{ caption_text: "Qui dolore fugit rem.", copyright: "Zane Marquardt", height: 342, width: 215, content_type: "image", source_url_attributes: { url: "https://www.image.file", description: "main image" } }, { caption_text: "Id molestias omnis repellat.", copyright: "Dr. Willard Klocko", height: 315, width: 607, content_type: "video" }, { caption_text: "Provident quidem sed velit.", copyright: "Verona Lowe", height: 348, width: 766, content_type: "soundcloud-audio" }], organizer_attributes: { name: "McClure, Kemmer and Brown", address_attributes: { street: "Abbie Manors", zip: "25083", city: "Mialand", kind: "default", geo_location_attributes: { latitude: 7.45018, longitude: 102.279 } }, contact_attributes: { first_name: "Alonzo", last_name: "Von", phone: "+235 782-754-0007 x80976", web_urls_attributes: [{ url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }] } }, price_informations_attributes: [{ name: "Standardkarte", amount: 5.89, group_price: false, description: "Tarif gilt nicht in den Ferien" }, { name: "Familienkarte", amount: 18.0, group_price: true, age_from: 2, age_to: 17, min_adult_count: 10, max_adult_count: 17, min_children_count: 3, max_children_count: 9, description: "Tarif gilt nur in den Ferien." }], accessibility_information_attributes: { description: "bla", types: "Tops", urls_attributes: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }] }, tag_list: ["megaparty", "technoclassix", "underground"] }
  end

  describe "#create" do
    context "when creating a 'maz-NewsItem'" do
      context "with an external_id which already exists in the database" do
        before do
          news_item_1
          news_item_2
        end

        it "deletes the old record" do
          expect(NewsItem.exists?(news_item_1.id)).to eq(false)
        end
        it "creates a new record" do
          expect(NewsItem.exists?(news_item_2.id)).to eq(true)
        end
        it "the new record has the same external_id as the old one" do
          expect(news_item_1.external_id).to eq(news_item_2.external_id)
        end
      end
    end

    context "when creating any other resource" do
      context "which is exactly matching an exiting one" do
        before do
          poi_1
          tour_1
          event_1
        end

        it "doesn't create a new record" do
          poi_2
          tour_2
          event_2
          expect(poi_2.id).to eq(poi_1.id)
          expect(tour_2.id).to eq(tour_1.id)
          expect(event_2.id).to eq(event_1.id)
        end
        it "returns the existing record" do
          poi_2
          tour_2
          event_2
          expect(poi_2).to eq(poi_1)
          expect(tour_2).to eq(tour_1)
          expect(event_2).to eq(event_1)
        end
      end

      context "which is changing an exiting one" do
        before do
          poi_1
          tour_1
          event_1
        end

        it "creates a new record" do
          poi_1_changed
          tour_1_changed
          event_1_changed
          expect(poi_1_changed.id).not_to eq(poi_1.id)
          expect(tour_1_changed.id).not_to eq(tour_1.id)
          expect(event_1_changed.id).not_to eq(event_1.id)
          expect(PointOfInterest.exists?(poi_1_changed.id)).to eq(true)
          expect(Tour.exists?(tour_1_changed.id)).to eq(true)
          expect(EventRecord.exists?(event_1_changed.id)).to eq(true)
        end
        it "destroys the old record" do
          poi_1_changed
          tour_1_changed
          event_1_changed
          expect(PointOfInterest.exists?(poi_1.id)).to eq(false)
          expect(Tour.exists?(tour_1.id)).to eq(false)
          expect(EventRecord.exists?(event_1.id)).to eq(false)
        end
      end
    end
  end
end
