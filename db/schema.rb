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

ActiveRecord::Schema.define(version: 2022_02_16_021717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.string "currency"
    t.decimal "total_equity"
    t.decimal "cash"
    t.decimal "market_value"
    t.bigint "integration_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "yesterday_start_equity"
    t.index ["integration_id"], name: "index_balances_on_integration_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "client_key"
    t.string "client_secret"
    t.string "host_server"
    t.index ["user_id"], name: "index_integrations_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.decimal "amount", null: false
    t.bigint "integration_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "account", default: {"type"=>"", "id"=>"", "status"=>""}
    t.decimal "price"
    t.decimal "open_pnl"
    t.decimal "yesterday_start_equity"
    t.index ["integration_id"], name: "index_positions_on_integration_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone", default: ""
    t.boolean "send_daily_email", default: false
    t.json "onboarding", default: {"has_integration"=>false, "has_choosen_option"=>false}
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "balances", "integrations"
  add_foreign_key "integrations", "users"
  add_foreign_key "positions", "integrations"
end
