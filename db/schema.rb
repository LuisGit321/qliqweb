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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "agency_employee", :force => true do |t|
    t.integer "billing_agency_id"
    t.string  "name",              :limit => 50
    t.integer "employee_number"
    t.string  "phone",             :limit => 25
    t.string  "address",           :limit => 50
    t.string  "city",              :limit => 50
    t.string  "state",             :limit => 5
    t.string  "zip",               :limit => 10
  end

  add_index "agency_employee", ["billing_agency_id"], :name => "billing_agency_id_idx"

  create_table "app_registration", :force => true do |t|
    t.integer "physician_id"
    t.string  "app_unique_key", :limit => 50
  end

  add_index "app_registration", ["physician_id"], :name => "physician_id_idx"

  create_table "app_yet_tobe_registered", :force => true do |t|
    t.integer "physician_id"
    t.string  "onetime_password", :limit => 50
  end

  add_index "app_yet_tobe_registered", ["physician_id"], :name => "physician_id_idx01"

  create_table "appointment", :force => true do |t|
    t.integer "patient_id"
    t.integer "physician_id"
    t.integer "facility_id"
    t.date    "appt_date"
    t.time    "appt_start"
    t.time    "appt_end"
    t.text    "reason"
    t.string  "room",                   :limit => 50
    t.string  "location",               :limit => 50
    t.integer "reminder"
    t.string  "mrn",                    :limit => 50
    t.integer "referring_physician_id"
    t.integer "complete",                             :default => 0
  end

  add_index "appointment", ["facility_id"], :name => "facility_id"
  add_index "appointment", ["patient_id"], :name => "patient_id"
  add_index "appointment", ["physician_id"], :name => "physician_id"
  add_index "appointment", ["referring_physician_id"], :name => "referring_physician_id"

  create_table "billing_agency", :force => true do |t|
    t.string "address",    :limit => 50
    t.string "city",       :limit => 50
    t.string "state",      :limit => 5
    t.string "zip",        :limit => 10
    t.string "phone",      :limit => 25
    t.string "fax",        :limit => 15
    t.string "first_name"
    t.string "last_name"
  end

  create_table "billing_batch", :force => true do |t|
    t.integer "encounter_id"
    t.integer "agencyemployee_id"
    t.integer "group_id"
    t.integer "physician_id"
    t.date    "exported_date"
    t.string  "exported_filename", :limit => 50
  end

  add_index "billing_batch", ["agencyemployee_id"], :name => "agencyemployee_id_idx"
  add_index "billing_batch", ["encounter_id"], :name => "encounter_id_idx"
  add_index "billing_batch", ["group_id"], :name => "group_id_idx"
  add_index "billing_batch", ["physician_id"], :name => "physician_id_idx02"

  create_table "billing_infos", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "phone"
    t.string   "email"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "credit_card_number"
    t.integer  "ex_month"
    t.integer  "ex_year"
    t.integer  "cvc_code"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.boolean  "is_account_info",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_pref", :force => true do |t|
    t.integer "billing_agency_id"
    t.integer "physician_group_id"
  end

  add_index "billing_pref", ["billing_agency_id"], :name => "billing_agency_id"

  create_table "billing_report", :force => true do |t|
    t.integer  "user_id"
    t.string   "group_name",     :limit => 20
    t.string   "physician",      :limit => 20
    t.date     "processed_date"
    t.text     "report_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buddylist", :id => false, :force => true do |t|
    t.string "user_id",       :limit => 50, :null => false
    t.string "buddy_user_id", :limit => 50, :null => false
  end

  add_index "buddylist", ["buddy_user_id"], :name => "buddy_user_id"
  add_index "buddylist", ["user_id"], :name => "user_id"

  create_table "carts", :force => true do |t|
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "census", :force => true do |t|
    t.integer "patient_id"
    t.integer "physician_id"
    t.integer "facility_id"
    t.string  "mrn",                    :limit => 50
    t.integer "room"
    t.date    "admit_date"
    t.date    "discharge_date"
    t.integer "referring_physician_id"
    t.integer "active"
  end

  add_index "census", ["facility_id"], :name => "facility_id"
  add_index "census", ["patient_id"], :name => "patient_id"
  add_index "census", ["physician_id"], :name => "physician_id"
  add_index "census", ["referring_physician_id"], :name => "referring_physician_id"

  create_table "cpt", :force => true do |t|
    t.string  "code",         :limit => 50
    t.text    "description"
    t.string  "short_key",    :limit => 50
    t.integer "version_year"
  end

  create_table "cpt_group", :force => true do |t|
    t.string "name", :limit => 50
  end

  create_table "custom_procedure", :id => false, :force => true do |t|
    t.integer "physician_id"
    t.text    "description"
  end

  add_index "custom_procedure", ["physician_id"], :name => "physician_id"

  create_table "encounter", :force => true do |t|
    t.integer "census_id"
    t.integer "appt_id"
    t.date    "date_of_service"
    t.integer "attending_physician_id"
    t.integer "status"
    t.date    "complete_date"
    t.date    "pull_date"
  end

  add_index "encounter", ["appt_id"], :name => "appt_id"
  add_index "encounter", ["attending_physician_id"], :name => "attending_physician_id"
  add_index "encounter", ["census_id"], :name => "census_id"

  create_table "encounter_cpt", :force => true do |t|
    t.integer  "encounter_id"
    t.integer  "superbill_cpt_id"
    t.datetime "queued_date"
    t.datetime "pulled_date"
  end

  add_index "encounter_cpt", ["encounter_id"], :name => "encounter_id"
  add_index "encounter_cpt", ["superbill_cpt_id"], :name => "superbill_cpt_id"

  create_table "encounter_cpt_modifier", :force => true do |t|
    t.integer "encounter_cpt_id"
    t.string  "modifier",         :limit => 25
  end

  add_index "encounter_cpt_modifier", ["encounter_cpt_id"], :name => "encounter_cpt_id"

  create_table "encounter_icd", :force => true do |t|
    t.integer "encounter_id"
    t.integer "encounter_cpt_id"
    t.integer "icd_id"
    t.integer "primary_diagnosis", :limit => 2
  end

  add_index "encounter_icd", ["encounter_cpt_id"], :name => "encounter_cpt_id"
  add_index "encounter_icd", ["encounter_id"], :name => "encounter_id"
  add_index "encounter_icd", ["icd_id"], :name => "icd_id"

  create_table "encounter_note", :force => true do |t|
    t.integer "encounter_id"
    t.integer "note_id"
    t.integer "type_id"
    t.text    "text_note"
    t.binary  "voice_note"
    t.binary  "picture_note"
  end

  add_index "encounter_note", ["encounter_id"], :name => "encounter_id"
  add_index "encounter_note", ["note_id"], :name => "note_id"
  add_index "encounter_note", ["type_id"], :name => "type_id"

  create_table "facility", :force => true do |t|
    t.integer "facility_type_id"
    t.decimal "medicare_id",                       :precision => 15, :scale => 0
    t.string  "name",                :limit => 50
    t.string  "address",             :limit => 50
    t.string  "city",                :limit => 50
    t.string  "state",               :limit => 5
    t.string  "zip",                 :limit => 10
    t.string  "county",              :limit => 50
    t.string  "phone",               :limit => 25
    t.integer "resource_id"
    t.string  "resource_type",       :limit => 20
    t.boolean "visibility_to_group",                                              :default => false
  end

  add_index "facility", ["facility_type_id"], :name => "facility_type_id"

  create_table "facility_type", :force => true do |t|
    t.string "name", :limit => 50
  end

  create_table "favorite_facility", :force => true do |t|
    t.integer "physician_id"
    t.integer "facility_id"
  end

  add_index "favorite_facility", ["facility_id"], :name => "facility_id_idx"
  add_index "favorite_facility", ["physician_id"], :name => "physician_id_idx04"

  create_table "favorite_icd", :force => true do |t|
    t.integer "physician_id"
    t.integer "icd_id"
  end

  add_index "favorite_icd", ["icd_id"], :name => "icd_id_idx01"
  add_index "favorite_icd", ["physician_id"], :name => "physician_id_idx05"

  create_table "hospital_episode", :primary_key => "patient_id", :force => true do |t|
    t.integer "floor"
    t.integer "room"
    t.date    "admit_date"
    t.date    "discharge_date"
    t.integer "primary_physician_id"
    t.integer "referring_physician_id"
  end

  add_index "hospital_episode", ["primary_physician_id"], :name => "primary_physician_id"
  add_index "hospital_episode", ["referring_physician_id"], :name => "referring_physician_id"

  create_table "icd", :force => true do |t|
    t.string  "code",             :limit => 50
    t.text    "description"
    t.integer "version_year"
    t.text    "long_description"
    t.text    "pft"
  end

  add_index "icd", ["code"], :name => "icd_code_idx01"

  create_table "im", :force => true do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.decimal "send_timestamp",                :precision => 25, :scale => 0
    t.decimal "recv_timestamp",                :precision => 25, :scale => 0
    t.text    "message",        :limit => 255
  end

  create_table "line_items", :force => true do |t|
    t.float    "price"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location", :force => true do |t|
    t.string "location", :limit => 45
  end

  create_table "master_cpt_pft", :primary_key => "cpt_code", :force => true do |t|
    t.string "pft", :limit => 256
  end

  create_table "master_icd_pft", :primary_key => "icd_code", :force => true do |t|
    t.string "pft", :limit => 256
  end

  create_table "modifiers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note", :force => true do |t|
    t.integer "type_id"
    t.text    "text_note"
    t.binary  "voice_note"
    t.binary  "picture_note"
  end

  add_index "note", ["type_id"], :name => "type_id"

  create_table "note_type", :force => true do |t|
    t.text "description"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "suite"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.string   "name_on_card"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient", :force => true do |t|
    t.string  "first_name",    :limit => 50
    t.string  "middle_name",   :limit => 50
    t.string  "last_name",     :limit => 50
    t.date    "date_of_birth"
    t.string  "race",          :limit => 50
    t.string  "gender",        :limit => 50
    t.string  "phone",         :limit => 25
    t.string  "email",         :limit => 50
    t.string  "insurance",     :limit => 50
    t.integer "physician_id"
    t.integer "facility_id"
  end

  add_index "patient", ["facility_id"], :name => "facility_id"
  add_index "patient", ["physician_id"], :name => "physician_id"

  create_table "physician", :force => true do |t|
    t.integer "group_id"
    t.integer "group_flag",          :limit => 2
    t.string  "initials",            :limit => 2
    t.string  "specialty",           :limit => 50
    t.string  "state",               :limit => 2
    t.string  "zip",                 :limit => 10
    t.string  "npi",                 :limit => 50
    t.string  "mobile",              :limit => 15
    t.string  "phone",               :limit => 25
    t.string  "fax",                 :limit => 15
    t.string  "email",               :limit => 50
    t.string  "password",            :limit => 50
    t.integer "subscribe_to_iphone"
    t.integer "subscribe_to_web"
    t.string  "salutation",          :limit => 5,  :default => "Dr."
    t.integer "no_of_billing_days"
    t.integer "print_id"
    t.string  "first_name"
    t.string  "last_name"
  end

  add_index "physician", ["group_id"], :name => "group_id"

  create_table "physician_cpt_pft", :primary_key => "cpt_code", :force => true do |t|
    t.string "pft", :limit => 256
  end

  create_table "physician_group", :force => true do |t|
    t.string   "name",             :limit => 50
    t.string   "address",          :limit => 50
    t.string   "city",             :limit => 50
    t.string   "state",            :limit => 5
    t.string   "zip",              :limit => 10
    t.string   "phone",            :limit => 25
    t.string   "fax",              :limit => 15
    t.string   "admin_email",      :limit => 50
    t.string   "admin_password",   :limit => 50
    t.boolean  "is_user_required",               :default => false
    t.integer  "print_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_title"
    t.string   "address2"
    t.integer  "providers"
    t.boolean  "paid",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "physician_itself",               :default => false
  end

  create_table "physician_icd_pft", :primary_key => "icd_code", :force => true do |t|
    t.string "pft", :limit => 256
  end

  create_table "physician_pref", :force => true do |t|
    t.integer "physician_id"
    t.integer "number_of_days_to_bill"
    t.integer "fax_to_primary"
    t.integer "defacto_facility_id"
  end

  add_index "physician_pref", ["defacto_facility_id"], :name => "defacto_facility_id_idx"
  add_index "physician_pref", ["physician_id"], :name => "physician_id_idx07"

  create_table "physician_superbill", :force => true do |t|
    t.integer "physician_id"
    t.integer "facility_type_id"
    t.integer "superbill_id"
    t.integer "preferred",        :limit => 2
  end

  add_index "physician_superbill", ["facility_type_id"], :name => "facility_type_id"
  add_index "physician_superbill", ["physician_id"], :name => "physician_id"
  add_index "physician_superbill", ["superbill_id"], :name => "superbill_id"

  create_table "prints", :force => true do |t|
    t.string   "image_file_name",    :limit => 100
    t.string   "image_file_size",    :limit => 50
    t.string   "image_content_type", :limit => 50
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prospective_physician_groups", :force => true do |t|
    t.integer  "prospective_subscriber_id"
    t.string   "name",                      :limit => 50
    t.string   "address",                   :limit => 50
    t.string   "city",                      :limit => 50
    t.string   "state",                     :limit => 5
    t.string   "zip",                       :limit => 10
    t.string   "phone",                     :limit => 25
    t.string   "fax",                       :limit => 15
    t.string   "admin_email",               :limit => 50
    t.string   "admin_password",            :limit => 50
    t.boolean  "is_user_required",                        :default => false
    t.integer  "print_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_title"
    t.string   "address2"
    t.integer  "providers"
    t.boolean  "paid",                                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prospective_subscriber_billing_addresses", :force => true do |t|
    t.integer  "prospective_subscriber_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "phone"
    t.string   "email"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_account_info",           :default => false
  end

  create_table "prospective_subscribers", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.integer  "passed_step"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt", :limit => 128, :default => ""
  end

  create_table "referring_physician", :force => true do |t|
    t.string  "name",                :limit => 50
    t.string  "address",             :limit => 50
    t.string  "city",                :limit => 50
    t.string  "state",               :limit => 5
    t.string  "zip",                 :limit => 10
    t.string  "phone",               :limit => 25
    t.string  "mobile",              :limit => 15
    t.string  "fax",                 :limit => 15
    t.string  "email",               :limit => 50
    t.string  "npi",                 :limit => 50
    t.string  "specialty",           :limit => 50
    t.integer "resource_id"
    t.string  "resource_type",       :limit => 20
    t.boolean "visibility_to_group",               :default => false
  end

  create_table "registrations", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 25
  end

  create_table "sessions", :primary_key => "session_id", :force => true do |t|
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialty", :force => true do |t|
    t.string "name", :limit => 45
  end

  create_table "state", :force => true do |t|
    t.string "code", :limit => 5
    t.string "name", :limit => 100
  end

  create_table "status", :force => true do |t|
    t.string "status", :limit => 45
  end

  create_table "superbill", :force => true do |t|
    t.string  "name",              :limit => 50
    t.integer "state_id"
    t.integer "specialty_id"
    t.integer "billing_agency_id"
  end

  add_index "superbill", ["billing_agency_id"], :name => "billing_agency_id"
  add_index "superbill", ["specialty_id"], :name => "specialty_id"
  add_index "superbill", ["state_id"], :name => "state_id"

  create_table "superbill_cpt", :force => true do |t|
    t.integer "superbill_id"
    t.integer "cpt_group_id"
    t.integer "group_display_order"
    t.integer "cpt_id"
    t.integer "cpt_display_oder"
    t.string  "modifier",            :limit => 45
  end

  add_index "superbill_cpt", ["cpt_group_id"], :name => "cpt_group_id"
  add_index "superbill_cpt", ["cpt_id"], :name => "cpt_id"
  add_index "superbill_cpt", ["superbill_id"], :name => "superbill_id"

  create_table "superbill_cpt_modifier", :force => true do |t|
    t.integer "superbill_cpt_id"
    t.integer "display_order"
    t.string  "modifier",         :limit => 45
    t.text    "description"
  end

  add_index "superbill_cpt_modifier", ["superbill_cpt_id"], :name => "superbill_cpt_id"

  create_table "superbill_icd", :force => true do |t|
    t.integer "superbill_id"
    t.integer "superbill_cpt_id"
    t.integer "icd_id"
  end

  add_index "superbill_icd", ["icd_id"], :name => "icd_id"
  add_index "superbill_icd", ["superbill_cpt_id"], :name => "superbill_cpt_id"
  add_index "superbill_icd", ["superbill_id"], :name => "superbill_id"

  create_table "superbill_modifiers", :force => true do |t|
    t.integer  "superbill_id"
    t.integer  "modifier_id"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sip_config", :primary_key => "user_id", :force => true do |t|
    t.string "display_name", :limit => 100
    t.string "sip_uri",      :limit => 50
    t.string "public_key",   :limit => 1024
  end

  create_table "user_sip_configs", :force => true do |t|
    t.integer  "user_id"
    t.string   "display_name"
    t.string   "sip_uri"
    t.string   "public_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                :limit => 50,  :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",        :limit => 128, :default => "", :null => false
    t.string   "reset_password_token", :limit => 50
    t.string   "remember_token",       :limit => 50
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   :limit => 15
    t.string   "last_sign_in_ip",      :limit => 15
    t.string   "confirmation_token",   :limit => 50
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token",         :limit => 50
    t.datetime "locked_at"
    t.string   "username",             :limit => 20
    t.integer  "resource_id"
    t.string   "resource_type",        :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
    t.string   "pin"
    t.string   "md5pin"
  end

  create_table "videos", :force => true do |t|
    t.string   "original_file_name",    :limit => 100
    t.string   "original_file_size",    :limit => 30
    t.string   "original_content_type", :limit => 30
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
