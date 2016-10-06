# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161006074417) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "royce_connector", force: :cascade do |t|
    t.integer  "roleable_id",   limit: 4,   null: false
    t.string   "roleable_type", limit: 255, null: false
    t.integer  "role_id",       limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_connector", ["role_id"], name: "index_royce_connector_on_role_id", using: :btree
  add_index "royce_connector", ["roleable_id", "roleable_type"], name: "index_royce_connector_on_roleable_id_and_roleable_type", using: :btree

  create_table "royce_role", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_role", ["name"], name: "index_royce_role_on_name", using: :btree

  create_table "scheme_operators", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "scheme_operators", ["email"], name: "index_scheme_operators_on_email", unique: true, using: :btree
  add_index "scheme_operators", ["reset_password_token"], name: "index_scheme_operators_on_reset_password_token", unique: true, using: :btree

  create_table "scheme_operators_schemes", id: false, force: :cascade do |t|
    t.integer "scheme_operator_id", limit: 4, null: false
    t.integer "scheme_id",          limit: 4, null: false
  end

  add_index "scheme_operators_schemes", ["scheme_id"], name: "index_scheme_operators_schemes_on_scheme_id", using: :btree
  add_index "scheme_operators_schemes", ["scheme_operator_id"], name: "index_scheme_operators_schemes_on_scheme_operator_id", using: :btree

  create_table "schemes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
