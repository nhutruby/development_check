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

ActiveRecord::Schema.define(:version => 20110527185630) do

  create_table "account_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credits"
    t.integer  "product_id"
    t.text     "description"
    t.string   "name"
    t.boolean  "allow_website",                  :default => false, :null => false
    t.boolean  "allow_email",                    :default => false, :null => false
    t.boolean  "allow_logo",                     :default => false, :null => false
    t.boolean  "allow_short_description",        :default => false, :null => false
    t.boolean  "allow_long_description",         :default => false, :null => false
    t.boolean  "allow_keywords",                 :default => false, :null => false
    t.boolean  "allow_location_primary_contact", :default => false, :null => false
    t.boolean  "allow_location_phone",           :default => false, :null => false
    t.boolean  "allow_location_website",         :default => false, :null => false
    t.boolean  "allow_tour_operator_search",     :default => false, :null => false
    t.boolean  "allow_association_directories",  :default => false, :null => false
    t.boolean  "allow_round_up",                 :default => false, :null => false
    t.boolean  "allow_buyer_blast",              :default => false, :null => false
    t.boolean  "allow_enhance_listing",          :default => false, :null => false
    t.integer  "user_limit"
    t.integer  "location_limit"
    t.boolean  "link_to_chargify",               :default => false, :null => false
    t.boolean  "is_trial"
    t.boolean  "is_travel_provider"
    t.integer  "price_in_cents"
    t.boolean  "allow_assets"
  end

  add_index "account_types", ["allow_association_directories"], :name => "index_account_types_on_allow_association_directories"
  add_index "account_types", ["allow_buyer_blast"], :name => "index_account_types_on_allow_buyer_blast"
  add_index "account_types", ["allow_email"], :name => "index_account_types_on_allow_email"
  add_index "account_types", ["allow_enhance_listing"], :name => "index_account_types_on_allow_enhance_listing"
  add_index "account_types", ["allow_keywords"], :name => "index_account_types_on_allow_keywords"
  add_index "account_types", ["allow_location_phone"], :name => "index_account_types_on_allow_location_phone"
  add_index "account_types", ["allow_location_primary_contact"], :name => "index_account_types_on_allow_location_primary_contact"
  add_index "account_types", ["allow_location_website"], :name => "index_account_types_on_allow_location_website"
  add_index "account_types", ["allow_logo"], :name => "index_account_types_on_allow_logo"
  add_index "account_types", ["allow_long_description"], :name => "index_account_types_on_allow_long_description"
  add_index "account_types", ["allow_round_up"], :name => "index_account_types_on_allow_round_up"
  add_index "account_types", ["allow_short_description"], :name => "index_account_types_on_allow_short_description"
  add_index "account_types", ["allow_tour_operator_search"], :name => "index_account_types_on_allow_tour_operator_search"
  add_index "account_types", ["allow_website"], :name => "index_account_types_on_allow_website"
  add_index "account_types", ["link_to_chargify"], :name => "index_account_types_on_link_to_chargify"
  add_index "account_types", ["location_limit"], :name => "index_account_types_on_location_limit"
  add_index "account_types", ["name"], :name => "index_account_types_on_name"
  add_index "account_types", ["user_limit"], :name => "index_account_types_on_user_limit"

  create_table "addresses", :force => true do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.float    "accuracy"
  end

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.text     "description"
    t.string   "name"
  end

  create_table "blog_comments", :force => true do |t|
    t.integer  "blog_post_id"
    t.integer  "user_id"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.string   "name"
    t.string   "site_url"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
  end

  add_index "blog_comments", ["blog_post_id"], :name => "index_blog_comments_on_blog_post_id"

  create_table "blog_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "blog_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_images", ["blog_post_id"], :name => "index_blog_images_on_blog_post_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",    :default => false, :null => false
    t.integer  "user_id"
    t.datetime "published_at"
  end

  create_table "blog_tags", :force => true do |t|
    t.integer "blog_post_id"
    t.string  "tag",          :null => false
  end

  add_index "blog_tags", ["blog_post_id"], :name => "index_blog_tags_on_blog_post_id"
  add_index "blog_tags", ["tag"], :name => "index_blog_tags_on_tag"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "requires_verification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipe"
    t.string   "marker_colors"
    t.string   "color",                 :default => "#FFFFFF"
    t.text     "synonym"
    t.text     "tags"
    t.integer  "position"
    t.text     "description"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "organization_id"
    t.boolean  "is_verified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizations", ["organization_id", "category_id"], :name => "index_categorizations_on_organization_id_and_category_id"

  create_table "connections", :force => true do |t|
    t.integer  "user_id"
    t.integer  "connection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_inner_circle"
    t.boolean  "is_approved"
  end

  create_table "contact_methods", :force => true do |t|
    t.string   "name"
    t.string   "lokation"
    t.string   "address"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entity_type"
    t.string   "extension"
  end

  add_index "contact_methods", ["name"], :name => "index_contact_methods_on_name"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "inventory_item_locations", :force => true do |t|
    t.integer  "location_id"
    t.integer  "inventory_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventory_items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expires_on"
    t.string   "url"
    t.boolean  "is_student_friendly"
    t.boolean  "is_deleted",          :default => false, :null => false
    t.boolean  "is_active",           :default => true
  end

  create_table "locations", :force => true do |t|
    t.integer  "address_id"
    t.integer  "primary_contact_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.string   "name"
    t.integer  "phone_id"
    t.string   "url"
    t.boolean  "is_deleted",         :default => false, :null => false
  end

  create_table "marker_colors", :force => true do |t|
    t.string   "color_name"
    t.boolean  "isactive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "organization_id"
    t.boolean  "is_organization_approved", :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["member_id"], :name => "index_memberships_on_member_id"
  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"

  create_table "notes", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "occurred_at"
    t.boolean  "is_alert"
    t.boolean  "is_sysmessage",        :default => false, :null => false
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_id"
    t.boolean  "is_fancybox_autoload"
    t.string   "permalink"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "description"
    t.integer  "account_id"
    t.integer  "primary_contact_id"
    t.string   "selected_plan",          :default => "free_plan"
    t.integer  "subscription_id"
    t.integer  "customer_id"
    t.string   "subscription_state"
    t.string   "billing_first_name"
    t.string   "billing_last_name"
    t.string   "billing_email"
    t.string   "url"
    t.string   "acronym"
    t.integer  "aba_id"
    t.string   "aba_email"
    t.string   "aba_contact"
    t.text     "long_description"
    t.integer  "syta_id"
    t.string   "syta_email"
    t.boolean  "is_student_friendly"
    t.boolean  "is_featured",            :default => false
    t.integer  "member_count"
    t.boolean  "is_motorcoach_friendly"
    t.integer  "owner_id"
    t.boolean  "is_deleted",             :default => false,       :null => false
    t.boolean  "is_complete"
    t.text     "keywords"
    t.boolean  "is_active",              :default => true
    t.boolean  "is_nta_member"
    t.datetime "trial_started_at"
    t.datetime "trial_ends_at"
    t.boolean  "trial_message_sent"
    t.integer  "account_type_id"
    t.string   "twitter_name"
    t.string   "facebook_url"
  end

  add_index "organizations", ["acronym"], :name => "index_organizations_on_acronym"
  add_index "organizations", ["id", "name"], :name => "index_organizations_on_id_and_name"
  add_index "organizations", ["is_motorcoach_friendly"], :name => "index_organizations_on_is_motorcoach_friendly"
  add_index "organizations", ["is_student_friendly"], :name => "index_organizations_on_is_student_friendly"
  add_index "organizations", ["keywords"], :name => "index_organizations_on_keywords"
  add_index "organizations", ["logo_file_name"], :name => "index_organizations_on_logo_file_name"
  add_index "organizations", ["member_count"], :name => "index_organizations_on_member_count"
  add_index "organizations", ["name"], :name => "index_organizations_on_name"
  add_index "organizations", ["owner_id"], :name => "index_organizations_on_owner_id"
  add_index "organizations", ["selected_plan"], :name => "index_organizations_on_selected_plan"
  add_index "organizations", ["url"], :name => "index_organizations_on_url"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postal_codes", :force => true do |t|
    t.string   "code",       :limit => 10
    t.string   "city",       :limit => 50
    t.string   "region"
    t.string   "tipe",       :limit => 25
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  add_index "postal_codes", ["city"], :name => "index_postal_codes_on_city"
  add_index "postal_codes", ["code"], :name => "index_postal_codes_on_code"
  add_index "postal_codes", ["country"], :name => "index_postal_codes_on_country"
  add_index "postal_codes", ["region"], :name => "index_postal_codes_on_region"

  create_table "prices", :force => true do |t|
    t.integer  "retail_low_cents",  :default => 0,    :null => false
    t.integer  "retail_high_cents", :default => 0,    :null => false
    t.integer  "price_low_cents",   :default => 0,    :null => false
    t.integer  "price_high_cents",  :default => 0,    :null => false
    t.boolean  "is_net",            :default => true, :null => false
    t.date     "expires_on"
    t.integer  "priceable_id"
    t.string   "priceable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.text     "changelog"
    t.string   "pricing_type"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "stars"
    t.integer  "user_id"
    t.boolean  "is_closed"
    t.boolean  "is_open"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["is_closed"], :name => "index_ratings_on_is_closed"
  add_index "ratings", ["is_open"], :name => "index_ratings_on_is_open"
  add_index "ratings", ["stars"], :name => "index_ratings_on_stars"

  create_table "recipients", :force => true do |t|
    t.integer  "note_id"
    t.boolean  "is_read",         :default => false, :null => false
    t.boolean  "is_deleted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "role_id"
  end

  create_table "roles", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_organization_approved"
    t.boolean  "is_user_approved"
    t.string   "title"
  end

  add_index "roles", ["is_admin"], :name => "index_roles_on_is_admin"
  add_index "roles", ["is_organization_approved"], :name => "index_roles_on_is_organization_approved"
  add_index "roles", ["is_user_approved"], :name => "index_roles_on_is_user_approved"
  add_index "roles", ["organization_id"], :name => "index_roles_on_organization_id"
  add_index "roles", ["title"], :name => "index_roles_on_title"

  create_table "users", :force => true do |t|
    t.string   "email",                                      :default => "",    :null => false
    t.string   "encrypted_password",                         :default => ""
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name_first"
    t.string   "name_last"
    t.boolean  "its_admin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",             :limit => 20
    t.datetime "invitation_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "temp_org_id"
    t.datetime "last_seen"
    t.boolean  "email_messages"
    t.boolean  "email_requests"
    t.boolean  "is_travel_planner"
    t.boolean  "is_active",                                  :default => true,  :null => false
    t.boolean  "email_newsletter"
    t.boolean  "email_special_offers"
    t.boolean  "is_deleted",                                 :default => false, :null => false
    t.integer  "invited_by_id"
    t.boolean  "is_coworker"
    t.string   "invited_by_type"
    t.string   "inviter_name"
    t.integer  "invitation_limit"
    t.integer  "invitee_trial_period_days"
    t.datetime "invitee_trial_period_ends_at"
    t.datetime "trial_period_ends_at"
    t.text     "message"
    t.string   "currency"
  end

  add_index "users", ["avatar_file_name"], :name => "index_users_on_avatar_file_name"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["is_travel_planner"], :name => "index_users_on_is_travel_planner"
  add_index "users", ["name_first"], :name => "index_users_on_name_first"
  add_index "users", ["name_last"], :name => "index_users_on_name_last"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
