# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081203140407) do

  create_table "assets", :force => true do |t|
    t.string   "caption"
    t.string   "title"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config", :force => true do |t|
    t.string "key",   :limit => 40, :default => "", :null => false
    t.string "value",               :default => ""
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "downloads", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "file"
    t.text     "description"
  end

  create_table "downloads_groups", :id => false, :force => true do |t|
    t.integer "download_id"
    t.integer "group_id"
  end

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "topics_count",     :default => 0
    t.integer  "posts_count",      :default => 0
    t.integer  "position"
    t.text     "description_html"
    t.integer  "filter_id"
    t.integer  "lock_version",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "for_comments"
  end

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "path"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",          :default => false, :null => false
    t.integer  "parent_id"
    t.boolean  "external",        :default => false
    t.integer  "children_count",  :default => 0,     :null => false
    t.integer  "accepts_uploads", :default => 0
  end

  create_table "gallery_items", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.text     "description"
    t.integer  "gallery_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "extension"
    t.string   "status"
    t.string   "photographer"
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "home_page_id"
    t.text     "description"
  end

  create_table "labellings", :force => true do |t|
    t.integer "label_id"
    t.string  "labelled_type"
    t.integer "labelled_id"
  end

  add_index "labellings", ["labelled_type", "labelled_id"], :name => "index_labellings_on_labelled"

  create_table "labels", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labels", ["title"], :name => "index_labels_on_title"

  create_table "layouts", :force => true do |t|
    t.string   "name",          :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "content_type",  :limit => 40
    t.integer  "lock_version",                 :default => 0
  end

  create_table "ldap_queries", :force => true do |t|
    t.string  "name"
    t.string  "filter"
    t.string  "base_dn"
    t.integer "scope"
    t.string  "attrs"
  end

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "moderatorships", :force => true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

  create_table "monitorships", :force => true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   :default => false
  end

  create_table "page_attachments", :force => true do |t|
    t.integer "asset_id"
    t.integer "page_id"
    t.integer "position"
  end

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content"
    t.integer "page_id"
  end

  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",            :limit => 100
    t.string   "breadcrumb",      :limit => 160
    t.string   "class_name",      :limit => 25
    t.integer  "status_id",                      :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                        :default => false, :null => false
    t.integer  "lock_version",                   :default => 0
    t.integer  "behavior_id"
    t.string   "description"
    t.string   "keywords"
    t.boolean  "commentable"
    t.boolean  "comments_closed"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "permissions", :force => true do |t|
    t.integer "group_id"
    t.integer "page_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
  end

  add_index "posts", ["forum_id", "created_at"], :name => "index_posts_on_forum_id"
  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "show_reports", :force => true do |t|
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.integer "year",                         :default => 2008
    t.boolean "can_attend_debrief"
    t.text    "duty"
    t.boolean "units_punctual",               :default => false
    t.text    "units_punctual_detail"
    t.boolean "units_obedient",               :default => false
    t.text    "units_obedient_detail"
    t.boolean "units_correct",                :default => false
    t.text    "units_correct_detail"
    t.boolean "units_briefed",                :default => false
    t.text    "units_briefed_detail"
    t.boolean "problems_assembly",            :default => false
    t.text    "problems_assembly_detail"
    t.boolean "problems_infiltration",        :default => false
    t.text    "problems_infiltration_detail"
    t.boolean "problems_outward",             :default => false
    t.text    "problems_outward_detail"
    t.boolean "problems_halt",                :default => false
    t.text    "problems_halt_detail"
    t.boolean "problems_reformation",         :default => false
    t.text    "problems_reformation_detail"
    t.boolean "problems_return",              :default => false
    t.text    "problems_return_detail"
    t.boolean "problems_dispersal",           :default => false
    t.text    "problems_dispersal_detail"
    t.boolean "problems_website",             :default => false
    t.text    "problems_website_detail"
    t.text    "report"
    t.boolean "sent",                         :default => false
  end

  create_table "snippets", :force => true do |t|
    t.string   "name",          :limit => 100, :default => "", :null => false
    t.string   "filter_id",     :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",         :default => 0
    t.integer  "sticky",       :default => 0
    t.integer  "posts_count",  :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",       :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
    t.integer  "page_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
  add_index "topics", ["page_id"], :name => "index_topics_on_page_id"

  create_table "user_config", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_property_id"
    t.string   "user_property_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "user_properties", :force => true do |t|
    t.string   "key"
    t.string   "title"
    t.string   "default"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                 :limit => 100
    t.string   "email"
    t.string   "login",                :limit => 40,  :default => "",    :null => false
    t.string   "password",             :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                               :default => false, :null => false
    t.boolean  "developer",                           :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                        :default => 0
    t.string   "salt"
    t.integer  "posts_count",                         :default => 0
    t.text     "description"
    t.text     "description_html"
    t.boolean  "receive_email"
    t.string   "activation_code"
    t.string   "provisional_password"
    t.string   "plaintext_password"
    t.datetime "activated_at"
    t.string   "session_token"
    t.string   "honorific"
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
