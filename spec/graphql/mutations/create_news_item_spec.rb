# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateNewsItem do
  let(:municipality) { create(:municipality) }
  let(:dp) { create(:data_provider, municipality_id: municipality.id) }
  let(:poi) { create(:point_of_interest, data_provider: dp) }

  def perform(**args)
    Mutations::CreateNewsItem.new(object: nil, context: {}, field: {}).resolve(args)
  end

  before do
    MunicipalityService.municipality_id = municipality.id
  end

  # rubocop:disable RSpec/ExampleLength
  it "creates a new and valid News Item" do
    news_item = perform(
      author: "Robert Reporter",
      point_of_interest_id: poi.id,
      full_version: true,
      characters_to_be_shown: 10_000,
      news_type: "story",
      publication_date: "05.03.2017",
      published_at: "07.07.2017",
      source_url_attributes: {
        url: "http://www.bbb-news.de",
        description: "source url of original article"
      },
      address_attributes: {
        street: "Abbie Manors",
        zip: "25083",
        city: "Mialand",
        kind: "default",
        geo_location_attributes: { latitude: 7.45018, longitude: 102.279 }
      },
      data_provider_attributes: {
        name: "MAZ",
        address_attributes: {
          addition: "Schwimmbad 2",
          street: "Strandstraße",
          zip: "10100",
          city: "Bad Belzig",
          geo_location_attributes: { latitude: 8_123_345.3726, longitude: 8_723_647.9347 }
        },
        contact_attributes: {
          first_name: "Tim",
          last_name: "Test",
          phone: "012345678",
          fax: "09843729047",
          web_urls_attributes: [{ url: "http://www.test1.de", description: "url 1" }, { url: "http://www.test2.de", description: "url 2" }],
          email: "test@test.de"
        },
        logo_attributes: { url: "https://www.logo-url.de", description: "url that lkeads to a logo image file" },
        description: "TMB dind die besten"
      },
      content_blocks_attributes: [
        {
          title: "Lorem ipsum dolor sit amet consectetur adipiscing",
          intro: "Lorem ante ultriceatm torquent sit volutpat. Eros malesuada pretium sociosqu magnis mauris parturient himenaeos suspendisse tincidunt conu.",
          body: "Lorem ipsum dolor sit amet consectetur adipiscing, elit tincidunt iaculis praesent ut. Nunc auctor posuere phasellus ultricies arcu hac, mollis dui aptent luctus gravida curae pulvinar, nibh vehicula eros dis etiam. Molestie dictumst curabitur taciti elementum commodo class ultricies libero turpis eget ac, parturient penatibus imperdiet lorem congue etiam phasellus tempus pharetra. Nascetur consequat laoreet imperdiet lectus venenatis mattis himenaeos pulvinar dolor nam primis, velit sodales taciti curae porta nisl malesuada dapibus mi. Malesuada hendrerit turpis himenaeos vestibulum sapien augue nostra erat lacus duis phasellus habitant, facilisis pretium iaculis commodo vivamus platea et eleifend tempor convallis tristique, lobortis cursus dapibus sem aenean mauris ac sagittis laoreet parturient senectus. Tortor eros curabitur congue ipsum vulputate dapibus montes tristique, accumsan hendrerit placerat praesent imperdiet laoreet mauris, luctus et turpis lacinia metus torquent lobortis.Interdum diam viverra libero hendrerit mauris adipiscing in odio faucibus, curae massa fusce nisi sed id tempor pulvinar, sit ante metus habitasse molestie fames nascetur rhoncus. Cum erat torquent tristique quis volutpat vulputate dui euismod sit integer, tincidunt iaculis non laoreet amet elementum nullam nascetur phasellus, potenti lacinia ultrices mauris vel habitant hac ligula feugiat pharetra, cras aptent leo lectus massa turpis tortor risus. Blandit montes sodales eros platea nascetur sociis eleifend nam vehicula ligula ipsum, ut dapibus mi augue leo congue bibendum volutpat mollis habitant est senectus, dis ante consectetur diam rhoncus potenti ornare varius vulputate vel. Sollicitudin commodo magna duis cursus quis curabitur, primis varius tempor eu eros erat, et faucibus nisl turpis consectetur. Non cras semper facilisis nunc posuere ultricies venenatis congue nec, curae taciti senectus pulvinar mollis tempus donec velit, pharetra potenti primis condimentum tristique convallis diam ad. Class aenean diam ad lobortis mollis montes suscipit tempus, duis molestie dui penatibus eget taciti habitant, ac vitae neque cursus quam primis accumsan.Odio sit sem aptent ipsum facilisis eleifend egestas, bibendum viverra ligula quis duis facilisi libero diam, ad vestibulum massa consectetur pellentesque conubia. Natoque eros iaculis aptent hac imperdiet at montes lacus lacinia fames, ante donec parturient justo lobortis porta magnis ullamcorper tortor cras, elit vel elementum in primis nec blandit pellentesque litora. Habitant massa ultricies primis ac diam, mus ullamcorper velit metus justo, nascetur dictumst magnis sollicitudin. Conubia faucibus est nec felis ornare inceptos purus, integer proin dis at tempor class porta commodo, donec auctor ad mollis bibendum curae. Consequat bibendum turpis sem duis accumsan pharetra, tristique potenti pretium integer nec, lacus placerat quam sodales sit. Rhoncus cras mus penatibus sed lacinia eget consectetur fusce class tincidunt, condimentum iaculis eu fames hendrerit metus feugiat vehicula per, elementum bibendum nam pretium vitae pulvinar ridiculus a lacus.",
          media_contents_attributes: [
            {
              caption_text: "Lorem ipsum dolor sit amet consectetur adipiscing",
              copyright: "Lorem Merol",
              height: 7865,
              width: 346,
              content_type: "image"
            }
          ]
        }
      ]
    )
    expect(news_item).to be_a(NewsItem)
    expect(news_item).to be_valid
  end
end
