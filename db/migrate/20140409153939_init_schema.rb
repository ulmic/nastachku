class InitSchema < ActiveRecord::Migration
  def up
    
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    
    create_table "audits", force: :cascade do |t|
      t.integer  "auditable_id"
      t.string   "auditable_type"
      t.integer  "user_id"
      t.string   "user_type"
      t.text     "modifications"
      t.string   "action"
      t.string   "tag"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "audits", ["action"], name: "index_audits_on_action", using: :btree
    add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
    add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
    add_index "audits", ["tag"], name: "index_audits_on_tag", using: :btree
    add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree
    
    create_table "authorizations", force: :cascade do |t|
      t.string   "provider"
      t.string   "uid"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "base_events", force: :cascade do |t|
      t.string   "title"
      t.text     "thesises"
      t.string   "presentation"
      t.integer  "speaker_id"
      t.string   "type"
      t.string   "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "workshop_id"
      t.integer  "listener_votings_count", default: 0
      t.integer  "lecture_votings_count",  default: 0
    end
    
    create_table "ckeditor_assets", force: :cascade do |t|
      t.string   "data_file_name",               null: false
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.integer  "assetable_id"
      t.string   "assetable_type",    limit: 30
      t.string   "type",              limit: 30
      t.integer  "width"
      t.integer  "height"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
    
    create_table "discounts", force: :cascade do |t|
      t.string   "code"
      t.datetime "begin_date"
      t.datetime "end_date"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "cost"
    end
    
    create_table "event_users", force: :cascade do |t|
      t.integer  "event_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "events", force: :cascade do |t|
      t.string   "title"
      t.string   "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description"
      t.string   "color"
      t.integer  "event_votings_count"
      t.boolean  "show_voting"
    end
    
    create_table "halls", force: :cascade do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state"
      t.integer  "position_sorting"
    end
    
    create_table "lectures", force: :cascade do |t|
      t.string   "state"
      t.string   "presentation"
      t.integer  "listener_votings_count", default: 0
      t.integer  "lecture_votings_count",  default: 0
      t.integer  "user_id"
      t.string   "title"
      t.text     "thesises"
      t.integer  "workshop_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "mail_params", force: :cascade do |t|
      t.text     "subject"
      t.text     "begin_of_greetings"
      t.text     "end_of_greetings"
      t.text     "mail_content"
      t.text     "before_link"
      t.text     "after_link"
      t.text     "goodbye"
      t.string   "email"
      t.text     "recipient_name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "news", force: :cascade do |t|
      t.string   "slug"
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "orders", force: :cascade do |t|
      t.integer  "user_id"
      t.string   "type"
      t.integer  "items_count"
      t.string   "item_size"
      t.string   "payment_state"
      t.string   "transaction_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "item_color"
      t.string   "ticket_type"
      t.integer  "cost"
      t.string   "payment_system"
      t.integer  "discounts"
    end
    
    create_table "pages", force: :cascade do |t|
      t.string   "slug"
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "sessions", force: :cascade do |t|
      t.string   "session_id", null: false
      t.text     "data"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
    add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
    
    create_table "slots", force: :cascade do |t|
      t.integer  "event_id"
      t.integer  "hall_id"
      t.datetime "start_time"
      t.datetime "finish_time"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "event_type"
    end
    
    create_table "topics", force: :cascade do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "user_auth_tokens", force: :cascade do |t|
      t.integer  "user_id"
      t.string   "authentication_token"
      t.datetime "expired_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "user_promo_codes", force: :cascade do |t|
      t.string   "code"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "user_topics", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "topic_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "users", force: :cascade do |t|
      t.string   "email"
      t.string   "password_digest"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "city"
      t.string   "company"
      t.boolean  "show_as_participant"
      t.string   "position"
      t.boolean  "admin"
      t.string   "password"
      t.string   "photo"
      t.string   "state"
      t.text     "about"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "role"
      t.integer  "sign_in_count"
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.text     "carousel_info"
      t.boolean  "in_carousel"
      t.string   "twitter_name"
      t.boolean  "invisible_lector"
      t.string   "timepad_state"
      t.boolean  "not_going_to_conference"
      t.string   "attending_conference_state"
      t.string   "pay_state"
      t.text     "facebook"
      t.text     "vkontakte"
      t.text     "reason_to_give_ticket"
      t.string   "badge_state"
    end
    
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    
    create_table "users_lists", force: :cascade do |t|
      t.text     "file"
      t.string   "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description"
    end
    
    create_table "votings", force: :cascade do |t|
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "type"
      t.integer  "voteable_id"
      t.string   "voteable_type"
    end
    
    create_table "workshops", force: :cascade do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "color"
      t.text     "icon"
    end
    
  end

  def down
    raise "Can not revert initial migration"
  end
end
