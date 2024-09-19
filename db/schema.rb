# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_09_19_160831) do

  create_table "accessibility_informations", charset: "utf8", force: :cascade do |t|
    t.text "description"
    t.string "types"
    t.string "accessable_type"
    t.bigint "accessable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accessable_type", "accessable_id"], name: "index_access_info_on_accessable_type_and_id"
    t.index ["accessable_type", "accessable_id"], name: "index_accessibility_informations_on_type_and_id"
  end

  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", charset: "utf8", force: :cascade do |t|
    t.string "addition"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.integer "kind", default: 0
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_type_and_id"
  end

  create_table "admins", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "app_user_contents", charset: "utf8", force: :cascade do |t|
    t.text "content"
    t.string "data_type"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipality_id"
  end

  create_table "attractions", charset: "utf8", force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.text "description"
    t.text "mobile_description"
    t.boolean "active", default: true
    t.integer "length_km"
    t.integer "means_of_transportation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "PointOfInterest", null: false
    t.integer "data_provider_id"
    t.boolean "visible", default: true
    t.text "payload"
    t.datetime "push_notifications_sent_at"
    t.index ["data_provider_id"], name: "index_attractions_on_data_provider_id"
    t.index ["external_id"], name: "index_attractions_on_external_id"
    t.index ["name"], name: "index_attractions_on_name"
    t.index ["type"], name: "index_attractions_on_type"
  end

  create_table "attractions_certificates", charset: "utf8", force: :cascade do |t|
    t.bigint "attraction_id"
    t.bigint "certificate_id"
    t.index ["attraction_id"], name: "index_attractions_certificates_on_attraction_id"
    t.index ["certificate_id"], name: "index_attractions_certificates_on_certificate_id"
  end

  create_table "attractions_regions", charset: "utf8", force: :cascade do |t|
    t.bigint "region_id"
    t.bigint "attraction_id"
    t.index ["attraction_id"], name: "index_attractions_regions_on_attraction_id"
    t.index ["region_id"], name: "index_attractions_regions_on_region_id"
  end

  create_table "categories", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "tmb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.integer "municipality_id"
    t.string "icon_name"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "certificates", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "point_of_interest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["point_of_interest_id"], name: "index_certificates_on_point_of_interest_id"
  end

  create_table "contacts", charset: "utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "contactable_type"
    t.bigint "contactable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_type_and_id"
  end

  create_table "content_blocks", charset: "utf8", force: :cascade do |t|
    t.text "title"
    t.text "intro"
    t.text "body"
    t.string "content_blockable_type"
    t.bigint "content_blockable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_blockable_type", "content_blockable_id"], name: "index_content_blocks_on_content_blockable_type_and_id"
    t.index ["content_blockable_type", "content_blockable_id"], name: "index_content_blocks_on_type_and_id"
  end

  create_table "data_providers", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "always_recreate"
    t.text "roles"
    t.integer "data_type", default: 0
    t.text "notice"
    t.integer "municipality_id"
    t.text "import_feeds", size: :medium
  end

  create_table "data_resource_categories", charset: "utf8", force: :cascade do |t|
    t.integer "data_resource_id"
    t.string "data_resource_type"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_data_resource_categories_on_category_id"
    t.index ["data_resource_id", "data_resource_type"], name: "index_drc_on_dr_id_and_dr_type"
  end

  create_table "data_resource_filters", charset: "utf8", force: :cascade do |t|
    t.string "data_resource_type"
    t.integer "municipality_id"
    t.text "config"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_resource_settings", charset: "utf8", force: :cascade do |t|
    t.integer "data_provider_id"
    t.string "data_resource_type"
    t.text "settings", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "global_settings", size: :medium
    t.index ["data_provider_id", "data_resource_type"], name: "index_dr_settings_on_dr_id_and_dr_type"
  end

  create_table "delayed_jobs", charset: "utf8", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "discount_types", charset: "utf8", force: :cascade do |t|
    t.decimal "original_price", precision: 10, scale: 2
    t.decimal "discounted_price", precision: 10, scale: 2
    t.decimal "discount_percentage", precision: 5
    t.decimal "discount_amount", precision: 10, scale: 2
    t.string "discountable_type"
    t.bigint "discountable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discountable_type", "discountable_id"], name: "index_discount_types_on_discountable_type_and_discountable_id"
  end

  create_table "event_records", charset: "utf8", force: :cascade do |t|
    t.integer "parent_id"
    t.bigint "region_id"
    t.text "description"
    t.boolean "repeat"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "data_provider_id"
    t.string "external_id"
    t.boolean "visible", default: true
    t.boolean "recurring", default: false
    t.string "recurring_weekdays"
    t.integer "recurring_type"
    t.integer "recurring_interval"
    t.datetime "sort_date"
    t.integer "point_of_interest_id"
    t.datetime "push_notifications_sent_at"
    t.index ["data_provider_id"], name: "index_event_records_on_data_provider_id"
    t.index ["external_id"], name: "index_event_records_on_external_id"
    t.index ["region_id"], name: "index_event_records_on_region_id"
  end

  create_table "external_references", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "unique_id"
    t.integer "data_provider_id"
    t.integer "external_id"
    t.string "external_type"
    t.index ["external_id", "external_type"], name: "index_external_references_on_id_and_type"
  end

  create_table "external_service_categories", charset: "utf8", force: :cascade do |t|
    t.string "external_id"
    t.bigint "external_service_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_external_service_categories_on_category_id"
    t.index ["external_service_id"], name: "index_external_service_categories_on_external_service_id"
  end

  create_table "external_service_credentials", charset: "utf8", force: :cascade do |t|
    t.string "client_key"
    t.string "client_secret"
    t.string "scopes"
    t.string "auth_type"
    t.string "external_id"
    t.bigint "external_service_id", null: false
    t.bigint "data_provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "additional_params"
    t.index ["data_provider_id"], name: "index_external_service_credentials_on_data_provider_id"
    t.index ["external_service_id"], name: "index_external_service_credentials_on_external_service_id"
  end

  create_table "external_services", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "base_uri"
    t.text "resource_config"
    t.integer "municipality_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "auth_path"
    t.string "preparer_type"
  end

  create_table "fixed_dates", charset: "utf8", force: :cascade do |t|
    t.date "date_start"
    t.date "date_end"
    t.string "weekday"
    t.time "time_start"
    t.time "time_end"
    t.text "time_description"
    t.boolean "use_only_time_description", default: false
    t.string "dateable_type"
    t.bigint "dateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_end"], name: "index_fixed_dates_on_date_end"
    t.index ["date_start"], name: "index_fixed_dates_on_date_start"
    t.index ["dateable_type", "dateable_id"], name: "index_fixed_dates_on_dateable_type_and_dateable_id"
    t.index ["dateable_type", "dateable_id"], name: "index_fixed_dates_on_type_and_id"
  end

  create_table "generic_item_messages", charset: "utf8", force: :cascade do |t|
    t.integer "generic_item_id"
    t.boolean "visible", default: true
    t.text "message"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.boolean "terms_of_service", default: false
  end

  create_table "generic_items", charset: "utf8", force: :cascade do |t|
    t.string "generic_type"
    t.text "author"
    t.datetime "publication_date"
    t.datetime "published_at"
    t.text "external_id"
    t.boolean "visible", default: true
    t.text "title"
    t.text "teaser"
    t.text "description"
    t.integer "data_provider_id"
    t.text "payload"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "generic_itemable_type"
    t.integer "generic_itemable_id"
    t.integer "member_id"
    t.datetime "push_notifications_sent_at"
    t.index ["data_provider_id"], name: "index_generic_items_on_data_provider_id"
  end

  create_table "geo_locations", charset: "utf8", force: :cascade do |t|
    t.float "latitude", limit: 53
    t.float "longitude", limit: 53
    t.string "geo_locateable_type"
    t.bigint "geo_locateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_locateable_id", "geo_locateable_type"], name: "index_geo_locations_on_locable_id_and_locaable_type"
    t.index ["geo_locateable_type", "geo_locateable_id"], name: "index_geo_locations_on_geo_locateable_type_and_geo_locateable_id"
    t.index ["latitude", "longitude"], name: "index_geo_locations_on_latitude_and_longitude"
  end

  create_table "locations", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.string "district"
    t.string "state"
    t.string "country"
    t.string "locateable_type"
    t.bigint "locateable_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locateable_type", "locateable_id"], name: "index_locations_on_locateable_type_and_locateable_id"
    t.index ["locateable_type", "locateable_id"], name: "index_locations_on_type_and_id"
    t.index ["name"], name: "index_locations_on_name"
    t.index ["region_id"], name: "index_locations_on_region_id"
  end

  create_table "lunch_offers", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "price"
    t.integer "lunch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lunches", charset: "utf8", force: :cascade do |t|
    t.text "text"
    t.integer "point_of_interest_id"
    t.string "point_of_interest_attributes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_contents", charset: "utf8", force: :cascade do |t|
    t.text "caption_text"
    t.string "copyright"
    t.string "height"
    t.string "width"
    t.string "content_type"
    t.string "mediaable_type"
    t.bigint "mediaable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mediaable_type", "mediaable_id"], name: "index_media_contents_on_mediaable_type_and_mediaable_id"
    t.index ["mediaable_type", "mediaable_id"], name: "index_media_contents_on_type_and_id"
  end

  create_table "members", charset: "utf8", force: :cascade do |t|
    t.string "keycloak_id"
    t.integer "municipality_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.text "authentication_token"
    t.datetime "authentication_token_created_at"
    t.text "keycloak_access_token"
    t.datetime "keycloak_access_token_expires_at"
    t.text "keycloak_refresh_token"
    t.datetime "keycloak_refresh_token_expires_at"
    t.text "preferences"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "unlock_token"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "messaging_conversation_participants", charset: "utf8", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "member_id", null: false
    t.boolean "email_notification_enabled", default: true
    t.boolean "push_notification_enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_messaging_conversation_participants_on_conversation_id"
    t.index ["member_id"], name: "index_messaging_conversation_participants_on_member_id"
  end

  create_table "messaging_conversations", charset: "utf8", force: :cascade do |t|
    t.string "conversationable_type", null: false
    t.bigint "conversationable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversationable_type", "conversationable_id"], name: "index_conversations_on_conversationable"
  end

  create_table "messaging_messages", charset: "utf8", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.text "message_text"
    t.bigint "sender_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_messaging_messages_on_conversation_id"
    t.index ["sender_id"], name: "fk_rails_b8f26a382d"
  end

  create_table "messaging_receipts", charset: "utf8", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "member_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_messaging_receipts_on_member_id"
    t.index ["message_id"], name: "index_messaging_receipts_on_message_id"
  end

  create_table "municipalities", charset: "utf8", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.text "settings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "global", default: false
  end

  create_table "news_items", charset: "utf8", force: :cascade do |t|
    t.string "author"
    t.boolean "full_version"
    t.integer "characters_to_be_shown"
    t.datetime "publication_date"
    t.datetime "published_at"
    t.boolean "show_publish_date"
    t.string "news_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "data_provider_id"
    t.text "external_id"
    t.string "title"
    t.boolean "visible", default: true
    t.datetime "push_notifications_sent_at"
    t.text "payload"
    t.integer "point_of_interest_id"
    t.index ["data_provider_id"], name: "index_news_items_on_data_provider_id"
  end

  create_table "notification_devices", charset: "utf8", force: :cascade do |t|
    t.string "token"
    t.integer "device_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipality_id"
    t.text "exclude_data_provider_ids"
    t.integer "member_id"
    t.text "exclude_mowas_regional_keys"
    t.text "exclude_notification_configuration"
    t.index ["token"], name: "index_notification_devices_on_token", unique: true
  end

  create_table "notification_push_device_assignments", charset: "utf8", force: :cascade do |t|
    t.integer "notification_push_id"
    t.integer "notification_device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_pushes", charset: "utf8", force: :cascade do |t|
    t.string "notification_pushable_type"
    t.bigint "notification_pushable_id"
    t.datetime "once_at"
    t.time "monday_at"
    t.time "tuesday_at"
    t.time "wednesday_at"
    t.time "thursday_at"
    t.time "friday_at"
    t.time "saturday_at"
    t.time "sunday_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recurring", default: 0
    t.string "title"
    t.string "body"
    t.text "data"
  end

  create_table "oauth_access_grants", charset: "utf8", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", charset: "utf8", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "open_weather_maps", charset: "utf8", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipality_id"
  end

  create_table "opening_hours", charset: "utf8", force: :cascade do |t|
    t.string "weekday"
    t.date "date_from"
    t.date "date_to"
    t.time "time_from"
    t.time "time_to"
    t.integer "sort_number"
    t.boolean "open"
    t.text "description"
    t.string "openingable_type"
    t.bigint "openingable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "use_year"
    t.index ["openingable_type", "openingable_id"], name: "index_opening_hours_on_openingable_type_and_openingable_id"
  end

  create_table "operating_companies", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "companyable_type"
    t.bigint "companyable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["companyable_type", "companyable_id"], name: "index_operating_companies_on_companyable_type_and_companyable_id"
  end

  create_table "prices", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.float "amount"
    t.boolean "group_price"
    t.integer "age_from"
    t.integer "age_to"
    t.integer "min_adult_count"
    t.integer "max_adult_count"
    t.integer "min_children_count"
    t.integer "max_children_count"
    t.text "description"
    t.string "category"
    t.string "priceable_type"
    t.bigint "priceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priceable_type", "priceable_id"], name: "index_prices_on_priceable_type_and_priceable_id"
  end

  create_table "quotas", charset: "utf8", force: :cascade do |t|
    t.integer "max_quantity"
    t.integer "frequency"
    t.integer "max_per_person"
    t.string "quotaable_type"
    t.bigint "quotaable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "visibility", default: 0
    t.index ["quotaable_type", "quotaable_id"], name: "index_quotas_on_quotaable_type_and_quotaable_id"
  end

  create_table "redemptions", charset: "utf8", force: :cascade do |t|
    t.integer "member_id"
    t.string "redemable_type"
    t.bigint "redemable_id"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "regions", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repeat_durations", charset: "utf8", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.boolean "every_year"
    t.bigint "event_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_record_id"], name: "index_repeat_durations_on_event_record_id"
  end

  create_table "reports", charset: "utf8", force: :cascade do |t|
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
  end

  create_table "static_contents", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "data_type"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
    t.integer "municipality_id"
    t.index ["data_type"], name: "index_static_contents_on_data_type"
    t.index ["name"], name: "index_static_contents_on_name"
    t.index ["version"], name: "index_static_contents_on_version"
  end

  create_table "survey_comments", charset: "utf8", force: :cascade do |t|
    t.integer "survey_poll_id"
    t.text "message"
    t.boolean "visible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_polls", charset: "utf8", force: :cascade do |t|
    t.text "title", size: :long
    t.text "description", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true
    t.integer "data_provider_id"
    t.boolean "can_comment", default: true
    t.boolean "is_multilingual", default: false
  end

  create_table "survey_questions", charset: "utf8", force: :cascade do |t|
    t.integer "survey_poll_id"
    t.text "title", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_multiple_responses", default: false
  end

  create_table "survey_response_options", charset: "utf8", force: :cascade do |t|
    t.integer "survey_question_id"
    t.text "title", size: :long
    t.integer "votes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tour_stop_assignments", charset: "utf8", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "tour_stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "data_provider_id"
    t.integer "role", default: 0
    t.text "authentication_token"
    t.datetime "authentication_token_created_at"
    t.integer "municipality_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, length: 255
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "municipality_id"], name: "index_email_on_municipality_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "waste_device_registrations", charset: "utf8", force: :cascade do |t|
    t.string "notification_device_token"
    t.string "street"
    t.string "city"
    t.string "zip"
    t.integer "notify_days_before", default: 0
    t.time "notify_at"
    t.string "notify_for_waste_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waste_location_types", charset: "utf8", force: :cascade do |t|
    t.string "waste_type"
    t.integer "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "waste_tour_id"
    t.integer "municipality_id"
  end

  create_table "waste_pick_up_times", charset: "utf8", force: :cascade do |t|
    t.integer "waste_location_type_id"
    t.date "pickup_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "waste_tour_id"
    t.integer "municipality_id"
  end

  create_table "waste_tours", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "waste_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipality_id"
  end

  create_table "web_urls", charset: "utf8", force: :cascade do |t|
    t.text "url"
    t.text "description"
    t.string "web_urlable_type"
    t.bigint "web_urlable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["web_urlable_type", "web_urlable_id"], name: "index_web_urls_on_type_and_id"
    t.index ["web_urlable_type", "web_urlable_id"], name: "index_web_urls_on_web_urlable_type_and_web_urlable_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "external_service_categories", "categories"
  add_foreign_key "external_service_categories", "external_services"
  add_foreign_key "external_service_credentials", "data_providers"
  add_foreign_key "external_service_credentials", "external_services"
  add_foreign_key "messaging_conversation_participants", "members"
  add_foreign_key "messaging_conversation_participants", "messaging_conversations", column: "conversation_id"
  add_foreign_key "messaging_messages", "members", column: "sender_id"
  add_foreign_key "messaging_messages", "messaging_conversations", column: "conversation_id"
  add_foreign_key "messaging_receipts", "members"
  add_foreign_key "messaging_receipts", "messaging_messages", column: "message_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
end
