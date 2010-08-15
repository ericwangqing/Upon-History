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

ActiveRecord::Schema.define(:version => 20100126071314) do

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diigo_annotations", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "diigo_bookmark_id"
    t.datetime "diigo_created_at"
  end

  create_table "diigo_bookmarks", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "diigo_created_at"
    t.datetime "diigo_updated_at"
  end

  create_table "diigo_bookmarks_diigo_tags", :id => false, :force => true do |t|
    t.integer "diigo_bookmark_id"
    t.integer "diigo_tag_id"
  end

  create_table "diigo_comments", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "diigo_bookmark_id"
    t.datetime "diigo_created_at"
  end

  create_table "diigo_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uha_anno_type", :force => true do |t|
    t.text "name",        :null => false
    t.text "description"
  end

  create_table "uha_annotations", :force => true do |t|
    t.integer "book_id",                  :null => false
    t.integer "type",                     :null => false
    t.integer "create_date", :limit => 8, :null => false
    t.integer "mod_date",    :limit => 8, :null => false
    t.integer "page",                     :null => false
    t.text    "content",                  :null => false
    t.integer "seq_number"
  end

  create_table "uha_book", :force => true do |t|
    t.text    "name",                  :null => false
    t.text    "docid1",                :null => false
    t.integer "last_ann", :limit => 8
    t.text    "path"
  end

end
