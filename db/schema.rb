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

ActiveRecord::Schema.define(version: 20161202214315) do

  create_table "address_types", force: :cascade do |t|
    t.string   "title",       limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

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

  create_table "agency_template_uploads", force: :cascade do |t|
    t.datetime "uploaded_at"
    t.integer  "scheme_id",        limit: 4
    t.integer  "uploaded_by_id",   limit: 4
    t.string   "uploaded_by_type", limit: 255
    t.integer  "year",             limit: 4
    t.string   "status",           limit: 255
    t.string   "filename",         limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "agency_template_uploads", ["scheme_id"], name: "index_agency_template_uploads_on_scheme_id", using: :btree

  create_table "business_subtype_codes", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "business_type_codes", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "membership_id", limit: 255
    t.string   "company_no",    limit: 255
    t.string   "NPWD",          limit: 255
    t.string   "SIC",           limit: 255
    t.integer  "scheme_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "businesses", ["scheme_id"], name: "index_businesses_on_scheme_id", using: :btree

  create_table "company_operators", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,     null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "business_id",            limit: 4
    t.string   "name",                   limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.boolean  "approved",                           default: false, null: false
  end

  add_index "company_operators", ["approved"], name: "index_company_operators_on_approved", using: :btree
  add_index "company_operators", ["business_id"], name: "index_company_operators_on_business_id", using: :btree
  add_index "company_operators", ["email"], name: "index_company_operators_on_email", unique: true, using: :btree
  add_index "company_operators", ["invitation_token"], name: "index_company_operators_on_invitation_token", unique: true, using: :btree
  add_index "company_operators", ["invitations_count"], name: "index_company_operators_on_invitations_count", using: :btree
  add_index "company_operators", ["invited_by_id"], name: "index_company_operators_on_invited_by_id", using: :btree
  add_index "company_operators", ["reset_password_token"], name: "index_company_operators_on_reset_password_token", unique: true, using: :btree

  create_table "leaving_codes", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "reason",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "packaging_sector_activities", force: :cascade do |t|
    t.string   "type",        limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "registration_status_codes", force: :cascade do |t|
    t.string   "status",      limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

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

  create_table "scheme_country_codes", force: :cascade do |t|
    t.string   "country",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scheme_operators", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                   limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.boolean  "approved",                           default: false, null: false
  end

  add_index "scheme_operators", ["approved"], name: "index_scheme_operators_on_approved", using: :btree
  add_index "scheme_operators", ["email"], name: "index_scheme_operators_on_email", unique: true, using: :btree
  add_index "scheme_operators", ["invitation_token"], name: "index_scheme_operators_on_invitation_token", unique: true, using: :btree
  add_index "scheme_operators", ["invitations_count"], name: "index_scheme_operators_on_invitations_count", using: :btree
  add_index "scheme_operators", ["invited_by_id"], name: "index_scheme_operators_on_invited_by_id", using: :btree
  add_index "scheme_operators", ["reset_password_token"], name: "index_scheme_operators_on_reset_password_token", unique: true, using: :btree

  create_table "scheme_operators_schemes", id: false, force: :cascade do |t|
    t.integer "scheme_operator_id", limit: 4, null: false
    t.integer "scheme_id",          limit: 4, null: false
  end

  add_index "scheme_operators_schemes", ["scheme_id"], name: "index_scheme_operators_schemes_on_scheme_id", using: :btree
  add_index "scheme_operators_schemes", ["scheme_operator_id"], name: "index_scheme_operators_schemes_on_scheme_operator_id", using: :btree

  create_table "scheme_status_codes", force: :cascade do |t|
    t.string   "status",      limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "schemes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "agency_template_uploads", "schemes"
  add_foreign_key "businesses", "schemes"
  add_foreign_key "company_operators", "businesses"
end
