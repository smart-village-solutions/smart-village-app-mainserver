# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(
  email: "tim@test.de",
  password: "kBzWAvNCWqn2rJxG", 
  password_confirmation: "kBzWAvNCWqn2rJxG",
  role: "admin"
)

data_provider = user.build_data_provider
roles_to_assign = {
  role_tour: true,
  role_point_of_interest: true,
  role_news_item: true,
  role_event_record: true,
  role_push_notification: true,
  role_survey: true,
  role_static_contents: true,
  role_deadlines: true,
  role_defect_report: true,
  role_lunch: true,
  role_waste_calendar: true,
  role_job: true,
  role_offer: true,
  role_construction_site: true,
  role_encounter_support: true,
  role_tour_stops: true,
  role_noticeboard: true,
}
data_provider.update(roles: roles_to_assign)

doorkeeper_app = Doorkeeper::Application.new name: "XML-Importer", redirect_uri: "http://localhost:3000/oauth/confirm_access"
doorkeeper_app.owner = user
doorkeeper_app.save

doorkeeper_app = Doorkeeper::Application.new name: "MAZ-Converter", redirect_uri: "http://localhost:5000/oauth/confirm_access"
doorkeeper_app.owner = user
doorkeeper_app.save

# Configs für den Abfallkalender
StaticContent.create(name: "wasteTypes", data_type: "json", content: File.read("doc/waste_types.json") )

#  = File.read("doc/waste_types.json")
def create_web_url
  WebUrl.create(url: Faker::Internet.url, description: Faker::Lorem.sentence)
end

def create_geo_location
  GeoLocation.create(latitude: Faker::Address.latitude, longitude: Faker::Address.longitude)
end

def create_categories
  cat_1 = Category.create(name: Faker::IndustrySegments.super_sector)
  cat_2 = Category.create(name: Faker::IndustrySegments.sector, parent: cat_1)
  Category.create(name: Faker::IndustrySegments.sub_sector, parent: cat_2)
end

def create_region
  Region.create(name: Faker::Address.country)
end

def create_contact
  contact = Contact.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number_with_country_code,
    fax: Faker::PhoneNumber.phone_number_with_country_code,
    email: Faker::Internet.email
  )
  contact.web_urls << create_web_url
  contact.save
  contact
end

def create_address(kind = 0)
  address = Address.create(
    addition: Faker::Lorem.word,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    zip: Faker::Address.zip,
    kind: kind
  )
  address.geo_location = create_geo_location
  address.save
  address
end

def create_data_provider
  data_provider = DataProvider.create(
    name: Faker::Company.name,
    description: Faker::Lorem.sentence,
    logo: create_web_url
  )
  data_provider.contact = create_contact
  data_provider.address = create_address
  data_provider.save
  data_provider
end

def create_operating_company
  op = OperatingCompany.create(
    name: Faker::Company.name
  )
  op.contact = create_contact
  op.address = create_address
  op.save
  op
end

def create_price(name = Faker::Commerce.product_name, _x = 1)
  prices = []
  prices << Price.create(
    name: name,
    amount: Faker::Commerce.price(range = 0..20.0),
    group_price: Faker::Boolean.boolean(0.2),
    age_from: Faker::Number.within(2..5),
    age_to: Faker::Number.within(10..18),
    min_adult_count: Faker::Number.within(1..10),
    max_adult_count: Faker::Number.within(10..20),
    min_children_count: Faker::Number.within(1..5),
    max_children_count: Faker::Number.within(5..10),
    description: Faker::Lorem.sentence
  )
end

def create_opening_hour
  OpeningHour.create(
    weekday: Faker::Date.between(2000.days.ago, Date.today).strftime("%A"),
    date_from: Faker::Date.backward,
    date_to: Faker::Date.forward,
    time_from: Faker::Time.backward,
    time_to: Faker::Time.forward,
    sort_number: Faker::Number.within(1..1_000_000),
    open: Faker::Boolean.boolean,
    description: Faker::Lorem.sentence
  )
end

def create_location
  loc = Location.create(
    name: Faker::Address.city,
    department: Faker::Address.country,
    district: Faker::Address.country,
    region: create_region,
    state: Faker::Address.state,
    country: Faker::Address.country
  )
  loc.geo_location = create_geo_location
  loc.save
  loc
end

def create_media_content
  media_content = MediaContent.create(
    caption_text: Faker::Lorem.sentence,
    copyright: Faker::Name.name,
    height: Faker::Number.number(3),
    width: Faker::Number.number(3),
    content_type: "image"
  )
  media_content.source_url = create_web_url
  media_content.save
  media_content
end

def create_accessibility_information
  ai = AccessibilityInformation.create(
    description: Faker::Lorem.sentence,
    types: Faker::Lorem.word
  )
  ai.urls << create_web_url
  ai.save
  ai
end

def create_certificate
  Certificate.create(
    name: "Qualitätszertifikat deutsche Burgen"
  )
end

def create_date
  FixedDate.create(
    weekday: Faker::Date.between(2000.days.ago, Date.today).strftime("%A"),
    date_start: Faker::Date.backward.strftime("%d.%m.%Y"),
    date_end: Faker::Date.forward.strftime("%d.%m.%Y"),
    time_start: Faker::Time.backward.strftime("%H:%M"),
    time_end: Faker::Time.forward.strftime("%H:%M"),
    time_description: Faker::Lorem.paragraph,
    use_only_time_description: Faker::Boolean.boolean(0.8)
  )
end

def create_content_block
  content_block = ContentBlock.create(
    title: Faker::Lorem.word,
    intro: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph
  )
  5.times do
    content_block.media_contents << create_media_content
    content_block.save
  end
  content_block
end

create_categories

10.times do |n|
  poi = PointOfInterest.create(
    name: "Burg #{n}",
    description: Faker::Lorem.paragraph,
    mobile_description: Faker::Lorem.paragraph,
    active: true,
    category_name: "Burgen und Schlösser",
    data_provider: create_data_provider
  )
  poi.addresses << create_address
  poi.contact = create_contact
  poi.operating_company = create_operating_company
  poi.web_urls << create_web_url
  6.times do
    poi.price_informations << create_price
    poi.opening_hours << create_opening_hour
    poi.media_contents << create_media_content
  end
  poi.certificates << create_certificate
  poi.accessibility_information = create_accessibility_information
  poi.location = create_location
  poi.tag_list.add("schöne Landschaft #{n}")
  poi.save
end

10.times do |n|
  tour = Tour.create(
    name: "Tour #{n}",
    description: Faker::Lorem.paragraph,
    mobile_description: Faker::Lorem.paragraph,
    active: true,
    category_name: "Schöne Fahrradrouten",
    length_km: Faker::Number.within(50..250),
    means_of_transportation: Faker::Number.within(0..2)
  )
  tour.addresses << create_address
  tour.contact = create_contact
  tour.data_provider = create_data_provider
  tour.operating_company = create_operating_company
  tour.web_urls << create_web_url
  6.times do
    tour.media_contents << create_media_content
    tour.regions << create_region
  end
  tour.certificates << create_certificate
  tour.accessibility_information = create_accessibility_information
  tour.tag_list.add("schöne Wege #{n}")
  tour.save
end

10.times do |n|
  event = EventRecord.create(
    title: "Konzert #{n}",
    description: Faker::Lorem.paragraph,
    repeat: Faker::Boolean.boolean(0.3),
    repeat_duration: RepeatDuration.create(
      start_date: Faker::Date.backward.strftime("%d.%m.%y"),
      end_date: Faker::Date.forward.strftime("%d.%m.%y"),
      every_year: Faker::Boolean.boolean(0.3)
    ),
    category_name: "Konzerte",
    region: create_region
  )
  event.addresses << create_address
  event.contacts << create_contact
  event.data_provider = create_data_provider
  event.organizer = create_operating_company
  event.urls << create_web_url
  6.times do
    event.price_informations << create_price
    event.media_contents << create_media_content
  end
  event.dates << create_date
  event.accessibility_information = create_accessibility_information
  event.location = create_location
  event.tag_list.add("Highlight des Jahres")
  event.save
end

10.times do
  news_item = NewsItem.create(
    author: Faker::Name.name,
    full_version: true,
    characters_to_be_shown: false,
    publication_date: "",
    published_at: Faker::Date.backward.strftime("%d.%m.%y"),
    show_publish_date: Faker::Boolean.boolean,
    news_type: "News article or story"
  )
  news_item.address = create_address
  news_item.data_provider = create_data_provider
  news_item.source_url = create_web_url
  5.times do
    news_item.content_blocks << create_content_block
  end
  news_item.save
end
