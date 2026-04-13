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

ActiveRecord::Schema[8.1].define(version: 2026_04_13_141208) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["item_id"], name: "index_favorites_on_item_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "post_date"
    t.integer "price"
    t.integer "reserver_id"
    t.bigint "seller_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "views"
    t.index ["category"], name: "index_items_on_category"
    t.index ["description"], name: "index_items_on_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_items_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["post_date"], name: "index_items_on_post_date"
    t.index ["price"], name: "index_items_on_price"
    t.index ["seller_id"], name: "index_items_on_seller_id"
    t.index ["status"], name: "index_items_on_status"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "location"
    t.string "name"
    t.string "password"
    t.string "password_digest"
    t.string "password_reset_code"
    t.datetime "password_reset_expires_at"
    t.datetime "updated_at", null: false
    t.index ["location"], name: "index_users_on_location"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "favorites", "items"
  add_foreign_key "favorites", "users"
  add_foreign_key "items", "users", column: "seller_id"
end
