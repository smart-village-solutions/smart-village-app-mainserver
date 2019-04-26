# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_26_112042) do

  create_table "accessibilty_informations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.string "types"
    t.string "accessable_type"
    t.bigint "accessable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accessable_type", "accessable_id"], name: "index_access_info_on_accessable_type_and_id"
  end

  create_table "adresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "addition"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.string "adressable_type"
    t.bigint "adressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adressable_type", "adressable_id"], name: "index_adresses_on_adressable_type_and_adressable_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "tmb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certificates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "point_of_interest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["point_of_interest_id"], name: "index_certificates_on_point_of_interest_id"
  end

  create_table "contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "url"
    t.string "contactable_type"
    t.bigint "contactable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "data_providers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.string "description"
    t.string "provideable_type"
    t.bigint "provideable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provideable_type", "provideable_id"], name: "index_data_providers_on_provideable_type_and_provideable_id"
  end

  create_table "geo_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "geo_locateable_type"
    t.bigint "geo_locateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_locateable_type", "geo_locateable_id"], name: "index_geo_locations_on_geo_locateable_type_and_geo_locateable_id"
  end

  create_table "locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.string "district"
    t.string "region"
    t.string "state"
    t.string "country"
    t.string "locateable_type"
    t.bigint "locateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locateable_type", "locateable_id"], name: "index_locations_on_locateable_type_and_locateable_id"
  end

  create_table "media_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "caption_text"
    t.string "copyright"
    t.string "height"
    t.string "width"
    t.string "link"
    t.string "type"
    t.string "source_url"
    t.string "mediable_type"
    t.bigint "mediable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mediable_type", "mediable_id"], name: "index_media_contents_on_mediable_type_and_mediable_id"
  end

  create_table "opening_hours", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "weekday"
    t.date "date_from"
    t.date "date_to"
    t.time "time_from"
    t.time "time_to"
    t.integer "sort_number"
    t.boolean "open"
    t.string "description"
    t.string "openingable_type"
    t.bigint "openingable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openingable_type", "openingable_id"], name: "index_opening_hours_on_openingable_type_and_openingable_id"
  end

  create_table "operating_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "companyable_type"
    t.bigint "companyable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["companyable_type", "companyable_id"], name: "index_operating_companies_on_companyable_type_and_companyable_id"
  end

  create_table "point_of_interests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "external_id"
    t.string "name"
    t.string "description"
    t.string "mobile_description"
    t.boolean "active"
    t.string "thumbnail_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.boolean "group_price"
    t.integer "age_from"
    t.integer "age_to"
    t.integer "min_adult_count"
    t.integer "max_adult_count"
    t.integer "min_children_count"
    t.integer "max_children_count"
    t.string "description"
    t.string "priceable_type"
    t.bigint "priceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priceable_type", "priceable_id"], name: "index_prices_on_priceable_type_and_priceable_id"
  end

  create_table "web_urls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "description"
    t.string "web_urlable_type"
    t.bigint "web_urlable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["web_urlable_type", "web_urlable_id"], name: "index_web_urls_on_web_urlable_type_and_web_urlable_id"
  end

end
