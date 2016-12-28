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

ActiveRecord::Schema.define(version: 20161225080451) do

  create_table "address_types", force: :cascade do |t|
    t.string   "title",       limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.integer  "business_id",     limit: 4,   null: false
    t.integer  "address_type_id", limit: 4,   null: false
    t.string   "address_line_1",  limit: 255, null: false
    t.string   "address_line_2",  limit: 255
    t.string   "address_line_3",  limit: 255
    t.string   "address_line_4",  limit: 255
    t.string   "town",            limit: 255
    t.string   "post_code",       limit: 255, null: false
    t.string   "site_country",    limit: 255
    t.string   "telephone",       limit: 255
    t.string   "fax",             limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "addresses", ["address_type_id"], name: "fk_rails_ba54156fb6", using: :btree
  add_index "addresses", ["business_id"], name: "fk_rails_493c8e25df", using: :btree

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
    t.datetime "uploaded_at",                  null: false
    t.integer  "scheme_id",        limit: 4,   null: false
    t.integer  "uploaded_by_id",   limit: 4,   null: false
    t.string   "uploaded_by_type", limit: 255, null: false
    t.integer  "year",             limit: 4,   null: false
    t.string   "status",           limit: 255
    t.string   "filename",         limit: 255, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "agency_template_uploads", ["scheme_id"], name: "index_agency_template_uploads_on_scheme_id", using: :btree

  create_table "annual_target_sets", force: :cascade do |t|
    t.integer  "scheme_country_code_id", limit: 4,                           null: false
    t.decimal  "value",                              precision: 5, scale: 2, null: false
    t.string   "year",                   limit: 255,                         null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "annual_target_sets", ["scheme_country_code_id"], name: "fk_rails_d2d9db2df5", using: :btree

  create_table "business_subtypes", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "business_types", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.integer  "scheme_id",                           limit: 4,   null: false
    t.integer  "membership_id",                       limit: 4
    t.string   "NPWD",                                limit: 255
    t.string   "name",                                limit: 255
    t.boolean  "small_producer"
    t.integer  "country_of_business_registration_id", limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "scheme_ref",                          limit: 255, null: false
    t.string   "company_number",                      limit: 255, null: false
    t.integer  "business_type_id",                    limit: 4
    t.integer  "business_subtype_id",                 limit: 4
    t.integer  "sic_code_id",                         limit: 4,   null: false
    t.string   "year_first_reg",                      limit: 255, null: false
    t.string   "year_last_reg",                       limit: 255
    t.integer  "scheme_status_code_id",               limit: 4
    t.integer  "registration_status_code_id",         limit: 4
    t.integer  "holding_business_id",                 limit: 4
  end

  add_index "businesses", ["scheme_id"], name: "index_businesses_on_scheme_id", using: :btree

  create_table "change_details", force: :cascade do |t|
    t.string   "modification", limit: 255, null: false
    t.string   "description",  limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

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
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.boolean  "approved",                           default: false, null: false
    t.string   "first_name",             limit: 255,                 null: false
    t.string   "last_name",              limit: 255,                 null: false
    t.string   "telephone",              limit: 255
    t.string   "fax",                    limit: 255
    t.boolean  "active"
  end

  add_index "company_operators", ["approved"], name: "index_company_operators_on_approved", using: :btree
  add_index "company_operators", ["business_id"], name: "index_company_operators_on_business_id", using: :btree
  add_index "company_operators", ["email"], name: "index_company_operators_on_email", unique: true, using: :btree
  add_index "company_operators", ["invitation_token"], name: "index_company_operators_on_invitation_token", unique: true, using: :btree
  add_index "company_operators", ["invitations_count"], name: "index_company_operators_on_invitations_count", using: :btree
  add_index "company_operators", ["invited_by_id"], name: "index_company_operators_on_invited_by_id", using: :btree
  add_index "company_operators", ["reset_password_token"], name: "index_company_operators_on_reset_password_token", unique: true, using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "business_id",   limit: 4,                   null: false
    t.string   "address_title", limit: 255,                 null: false
    t.string   "title",         limit: 255
    t.string   "first_name",    limit: 255,                 null: false
    t.string   "last_name",     limit: 255,                 null: false
    t.string   "email",         limit: 255
    t.string   "telephone_1",   limit: 255,                 null: false
    t.string   "telephone_2",   limit: 255
    t.string   "fax",           limit: 255
    t.boolean  "active",                    default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "contacts", ["business_id"], name: "fk_rails_5d1918d88d", using: :btree

  create_table "contacts_addresses", force: :cascade do |t|
    t.integer  "address_id", limit: 4, null: false
    t.integer  "contact_id", limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "contacts_addresses", ["address_id"], name: "fk_rails_baca6520ab", using: :btree
  add_index "contacts_addresses", ["contact_id"], name: "fk_rails_862a942894", using: :btree

  create_table "country_of_business_registrations", force: :cascade do |t|
    t.string   "country",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "emailed_reports", force: :cascade do |t|
    t.string   "report_name",       limit: 255
    t.string   "year",              limit: 255
    t.datetime "date_last_sent"
    t.integer  "business_id",       limit: 4
    t.integer  "emailed_status_id", limit: 4
    t.integer  "sent_by_id",        limit: 4
    t.string   "sent_by_type",      limit: 255
    t.string   "error_notices",     limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "emailed_reports", ["business_id"], name: "index_emailed_reports_on_business_id", using: :btree
  add_index "emailed_reports", ["emailed_status_id"], name: "index_emailed_reports_on_emailed_status_id", using: :btree

  create_table "emailed_statuses", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "joiners", force: :cascade do |t|
    t.integer  "agency_template_upload_id", limit: 4,                            null: false
    t.integer  "business_id",               limit: 4,                            null: false
    t.date     "joining_date",                                                   null: false
    t.date     "date_scheme_registered",                                         null: false
    t.string   "previously_registered_at",  limit: 255
    t.decimal  "total_recovery",                        precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "joiners", ["agency_template_upload_id"], name: "fk_rails_5b476c16f9", using: :btree
  add_index "joiners", ["business_id"], name: "fk_rails_a38bc3cfe3", using: :btree

  create_table "leavers", force: :cascade do |t|
    t.integer  "business_id",               limit: 4
    t.integer  "leaving_code_id",           limit: 4,                                           null: false
    t.integer  "agency_template_upload_id", limit: 4,                                           null: false
    t.integer  "leaving_business_id",       limit: 4
    t.date     "leaving_date",                                                                  null: false
    t.decimal  "total_recovery_previous",               precision: 6, scale: 2
    t.boolean  "sub_leaver",                                                    default: false
    t.string   "scheme_comments",           limit: 255
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
  end

  add_index "leavers", ["agency_template_upload_id"], name: "fk_rails_e783cea255", using: :btree
  add_index "leavers", ["business_id"], name: "fk_rails_a42f2cbe46", using: :btree
  add_index "leavers", ["leaving_business_id"], name: "fk_rails_71e28a1e96", using: :btree
  add_index "leavers", ["leaving_code_id"], name: "fk_rails_65d9f57c99", using: :btree

  create_table "leaving_businesses", force: :cascade do |t|
    t.string   "scheme_ref",          limit: 255
    t.string   "npwd",                limit: 255
    t.string   "company_name",        limit: 255
    t.string   "company_number",      limit: 255
    t.integer  "subsidiaries_number", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "leaving_codes", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "reason",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "licensors", force: :cascade do |t|
    t.integer  "business_id",               limit: 4, null: false
    t.integer  "agency_template_upload_id", limit: 4, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "licensors", ["agency_template_upload_id"], name: "fk_rails_e095df9179", using: :btree
  add_index "licensors", ["business_id"], name: "fk_rails_95a5dddad9", using: :btree

  create_table "material_details", force: :cascade do |t|
    t.integer  "regular_producer_detail_id", limit: 4,                          null: false
    t.integer  "packaging_material_id",      limit: 4,                          null: false
    t.decimal  "t1man",                                precision: 10, scale: 2, null: false
    t.decimal  "t1conv",                               precision: 10, scale: 2, null: false
    t.decimal  "t1pf",                                 precision: 10, scale: 2, null: false
    t.decimal  "t1sell",                               precision: 10, scale: 2, null: false
    t.decimal  "t2aman",                               precision: 10, scale: 2, null: false
    t.decimal  "t2aconv",                              precision: 10, scale: 2, null: false
    t.decimal  "t2apf",                                precision: 10, scale: 2, null: false
    t.decimal  "t2asell",                              precision: 10, scale: 2, null: false
    t.decimal  "t2bman",                               precision: 10, scale: 2, null: false
    t.decimal  "t2bconv",                              precision: 10, scale: 2, null: false
    t.decimal  "t2bpf",                                precision: 10, scale: 2, null: false
    t.decimal  "t2bsell",                              precision: 10, scale: 2, null: false
    t.decimal  "t3aconv",                              precision: 10, scale: 2, null: false
    t.decimal  "t3apf",                                precision: 10, scale: 2, null: false
    t.decimal  "t3asell",                              precision: 10, scale: 2, null: false
    t.decimal  "t3b",                                  precision: 10, scale: 2, null: false
    t.decimal  "t3c",                                  precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "material_details", ["packaging_material_id"], name: "fk_rails_63989b169c", using: :btree
  add_index "material_details", ["regular_producer_detail_id"], name: "fk_rails_f462f851d0", using: :btree

  create_table "material_targets", force: :cascade do |t|
    t.integer  "packaging_material_id", limit: 4,                            null: false
    t.integer  "annual_target_set_id",  limit: 4,                            null: false
    t.string   "year",                  limit: 255,                          null: false
    t.decimal  "value",                             precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "material_targets", ["annual_target_set_id"], name: "fk_rails_9799cbb55e", using: :btree
  add_index "material_targets", ["packaging_material_id"], name: "fk_rails_2a357ee575", using: :btree

  create_table "material_totals", force: :cascade do |t|
    t.integer  "regular_producer_detail_id", limit: 4,                          null: false
    t.integer  "packaging_material_id",      limit: 4,                          null: false
    t.decimal  "recycling_obligation",                 precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "material_totals", ["packaging_material_id"], name: "fk_rails_7e6a94d761", using: :btree
  add_index "material_totals", ["regular_producer_detail_id"], name: "fk_rails_72d20b62da", using: :btree

  create_table "packaging_materials", force: :cascade do |t|
    t.string   "name",            limit: 255,                 null: false
    t.string   "description",     limit: 255
    t.string   "year_introduced", limit: 255,                 null: false
    t.boolean  "active",                      default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "packaging_sector_main_activities", force: :cascade do |t|
    t.string   "material",    limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "registration_status_codes", force: :cascade do |t|
    t.string   "status",      limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "agency_template_upload_id",         limit: 4,                          null: false
    t.integer  "sic_code_id",                       limit: 4,                          null: false
    t.integer  "packaging_sector_main_activity_id", limit: 4,                          null: false
    t.integer  "submission_type_id",                limit: 4
    t.integer  "resubmission_reason_id",            limit: 4
    t.integer  "business_id",                       limit: 4,                          null: false
    t.decimal  "turnover",                                    precision: 10, scale: 2, null: false
    t.boolean  "licensor"
    t.boolean  "allocation_method_used"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "registrations", ["agency_template_upload_id"], name: "fk_rails_b77d53b2a3", using: :btree
  add_index "registrations", ["packaging_sector_main_activity_id"], name: "fk_rails_bb82cb95dd", using: :btree
  add_index "registrations", ["resubmission_reason_id"], name: "fk_rails_fe6ce2c717", using: :btree
  add_index "registrations", ["sic_code_id"], name: "fk_rails_b4a78f5f34", using: :btree
  add_index "registrations", ["submission_type_id"], name: "fk_rails_7aa93260c0", using: :btree

  create_table "regular_producer_details", force: :cascade do |t|
    t.integer  "registration_id",                                     limit: 4
    t.boolean  "calculation_method_supplier_data"
    t.boolean  "calculation_method_or_other_method_used"
    t.boolean  "calculation_method_sample_weighing"
    t.boolean  "calculation_method_sales_records"
    t.boolean  "calculation_method_trade_association_method_details"
    t.boolean  "consultant_system_used"
    t.string   "other_method_details",                                limit: 255
    t.string   "data_system_used",                                    limit: 255
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "regular_producer_details", ["registration_id"], name: "fk_rails_200684d40d", using: :btree

  create_table "report_event_data", force: :cascade do |t|
    t.string   "report_type",       limit: 255
    t.string   "year",              limit: 255
    t.integer  "current_user_id",   limit: 4
    t.string   "current_user_type", limit: 255
    t.string   "business_ids",      limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "resubmission_reasons", force: :cascade do |t|
    t.string   "reason",      limit: 255, null: false
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
    t.string   "country",     limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.boolean  "approved",                           default: false, null: false
    t.string   "first_name",             limit: 255,                 null: false
    t.string   "last_name",              limit: 255,                 null: false
    t.string   "telephone",              limit: 255
    t.string   "fax",                    limit: 255
    t.boolean  "active"
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
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "schemes", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.boolean  "active",                             default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "scheme_country_code_id", limit: 4,                   null: false
  end

  create_table "sic_codes", force: :cascade do |t|
    t.string   "code",            limit: 255,                 null: false
    t.string   "year_introduced", limit: 255
    t.boolean  "active",                      default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "small_producer_details", force: :cascade do |t|
    t.integer  "registration_id",                        limit: 4
    t.integer  "subsidiary_id",                          limit: 4
    t.string   "allocation_method_predominant_material", limit: 255, null: false
    t.integer  "allocation_method_obligation",           limit: 4,   null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "small_producer_details", ["registration_id"], name: "fk_rails_dbdafa2a38", using: :btree
  add_index "small_producer_details", ["subsidiary_id"], name: "fk_rails_25c374062c", using: :btree

  create_table "small_producer_obligations", force: :cascade do |t|
    t.decimal  "sme",                     precision: 10, scale: 2
    t.decimal  "glass_split",             precision: 10, scale: 2
    t.string   "year",        limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "submission_types", force: :cascade do |t|
    t.string   "code",        limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.integer  "business_id",                       limit: 4,                 null: false
    t.integer  "agency_template_upload_id",         limit: 4,                 null: false
    t.integer  "change_detail_id",                  limit: 4
    t.integer  "packaging_sector_main_activity_id", limit: 4,                 null: false
    t.boolean  "allocation_method_used",                      default: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "subsidiaries", ["agency_template_upload_id"], name: "fk_rails_8637b10479", using: :btree
  add_index "subsidiaries", ["business_id"], name: "fk_rails_75332f4c56", using: :btree
  add_index "subsidiaries", ["change_detail_id"], name: "fk_rails_c91c61f6f6", using: :btree
  add_index "subsidiaries", ["packaging_sector_main_activity_id"], name: "fk_rails_faf5299966", using: :btree

  create_table "target_fields", force: :cascade do |t|
    t.string   "name",            limit: 255, null: false
    t.string   "description",     limit: 255
    t.string   "year_introduced", limit: 255, null: false
    t.boolean  "active"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "target_totals", force: :cascade do |t|
    t.integer  "regular_producer_detail_id",                   limit: 4,                          null: false
    t.decimal  "total_recycling_obligation",                             precision: 10, scale: 2, null: false
    t.decimal  "total_recovery_obligation",                              precision: 10, scale: 2, null: false
    t.decimal  "total_material_specific_recycling_obligation",           precision: 10, scale: 2, null: false
    t.decimal  "adjusted_total_recovery_obligation",                     precision: 10, scale: 2, null: false
    t.decimal  "ninetytwo_percent_min_recycling_target",                 precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
  end

  add_index "target_totals", ["regular_producer_detail_id"], name: "fk_rails_4653c8a7c8", using: :btree

  create_table "targets", force: :cascade do |t|
    t.integer  "target_field_id",      limit: 4,                           null: false
    t.integer  "annual_target_set_id", limit: 4,                           null: false
    t.string   "year",                 limit: 255,                         null: false
    t.decimal  "value",                            precision: 5, scale: 2, null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "targets", ["annual_target_set_id"], name: "fk_rails_64aa8d93b5", using: :btree
  add_index "targets", ["target_field_id"], name: "fk_rails_2005fd91d8", using: :btree

  add_foreign_key "addresses", "address_types"
  add_foreign_key "addresses", "businesses"
  add_foreign_key "agency_template_uploads", "schemes"
  add_foreign_key "annual_target_sets", "scheme_country_codes"
  add_foreign_key "businesses", "schemes"
  add_foreign_key "company_operators", "businesses"
  add_foreign_key "contacts", "businesses"
  add_foreign_key "contacts_addresses", "addresses"
  add_foreign_key "contacts_addresses", "contacts"
  add_foreign_key "emailed_reports", "businesses"
  add_foreign_key "emailed_reports", "emailed_statuses"
  add_foreign_key "joiners", "agency_template_uploads", on_delete: :cascade
  add_foreign_key "joiners", "businesses"
  add_foreign_key "leavers", "agency_template_uploads", on_delete: :cascade
  add_foreign_key "leavers", "businesses"
  add_foreign_key "leavers", "leaving_businesses", on_delete: :cascade
  add_foreign_key "leavers", "leaving_codes", on_delete: :cascade
  add_foreign_key "licensors", "agency_template_uploads", on_delete: :cascade
  add_foreign_key "licensors", "businesses"
  add_foreign_key "material_details", "packaging_materials", on_delete: :cascade
  add_foreign_key "material_details", "regular_producer_details", on_delete: :cascade
  add_foreign_key "material_targets", "annual_target_sets"
  add_foreign_key "material_targets", "packaging_materials", on_delete: :cascade
  add_foreign_key "material_totals", "packaging_materials", on_delete: :cascade
  add_foreign_key "material_totals", "regular_producer_details", on_delete: :cascade
  add_foreign_key "registrations", "agency_template_uploads", on_delete: :cascade
  add_foreign_key "registrations", "packaging_sector_main_activities", on_delete: :cascade
  add_foreign_key "registrations", "resubmission_reasons"
  add_foreign_key "registrations", "sic_codes"
  add_foreign_key "registrations", "submission_types"
  add_foreign_key "regular_producer_details", "registrations", on_delete: :cascade
  add_foreign_key "small_producer_details", "registrations", on_delete: :cascade
  add_foreign_key "small_producer_details", "subsidiaries", on_delete: :cascade
  add_foreign_key "subsidiaries", "agency_template_uploads", on_delete: :cascade
  add_foreign_key "subsidiaries", "businesses"
  add_foreign_key "subsidiaries", "change_details", on_delete: :cascade
  add_foreign_key "subsidiaries", "packaging_sector_main_activities", on_delete: :cascade
  add_foreign_key "target_totals", "regular_producer_details", on_delete: :cascade
  add_foreign_key "targets", "annual_target_sets"
  add_foreign_key "targets", "target_fields"
end
