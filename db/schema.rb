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

ActiveRecord::Schema.define(version: 20180426153655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_emails", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_user_emails_by_email"
    t.index ["user_id"], name: "index_user_emails_on_user_id"
  end

  create_table "user_fax_numbers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_email_id", null: false
    t.string "fax_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_email_id"], name: "index_user_fax_numbers_on_user_email_id"
    t.index ["user_id"], name: "index_user_fax_numbers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fax_tag", null: false
    t.index ["fax_tag"], name: "index_users_by_fax_tag"
  end

end
