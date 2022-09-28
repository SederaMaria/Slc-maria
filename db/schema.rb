# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_07_21_093404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "rights", null: false
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_admin_id"], name: "index_actions_created_by_on_admin_user_id"
    t.index ["rights"], name: "index_actions_on_rights", unique: true
    t.index ["updated_by_admin_id"], name: "index_actions_updated_by_on_admin_user_id"
  end

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "county"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
  end

  create_table "adjusted_capitalized_cost_histories", force: :cascade do |t|
    t.integer "new_acquisition_fee_cents"
    t.integer "old_acquisition_fee_cents"
    t.bigint "adjusted_capitalized_cost_range_id"
    t.bigint "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adjusted_capitalized_cost_range_id"], name: "adj_cap_cost_histories"
    t.index ["admin_user_id"], name: "index_adjusted_capitalized_cost_histories_on_admin_user_id"
  end

  create_table "adjusted_capitalized_cost_ranges", force: :cascade do |t|
    t.integer "acquisition_fee_cents"
    t.integer "adjusted_cap_cost_lower_limit"
    t.integer "adjusted_cap_cost_upper_limit"
    t.bigint "credit_tier_id"
    t.datetime "effective_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_tier_id"], name: "index_adjusted_capitalized_cost_ranges_on_credit_tier_id"
  end

  create_table "admin_user_security_roles", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "security_role_id"
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_admin_user_security_roles_on_admin_user_id"
    t.index ["created_by_admin_id"], name: "index_admin_user_security_roles_created_by_on_admin_user_id"
    t.index ["security_role_id"], name: "index_admin_user_security_roles_on_security_role_id"
    t.index ["updated_by_admin_id"], name: "index_admin_user_security_roles_updated_by_on_admin_user_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "password_changed_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "is_active", default: true
    t.string "job_title"
    t.string "auth_token"
    t.datetime "auth_token_created_at"
    t.string "unique_session_id", limit: 20
    t.datetime "last_request_at"
    t.string "pinned_tabs"
    t.index ["auth_token", "auth_token_created_at"], name: "index_admin_users_on_auth_token_and_auth_token_created_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["password_changed_at"], name: "index_admin_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "name"
    t.string "access_token"
    t.datetime "access_token_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_token"], name: "index_api_tokens_on_access_token", unique: true
  end

  create_table "application_settings", id: :serial, force: :cascade do |t|
    t.integer "high_model_year", default: 2017, null: false
    t.integer "low_model_year", default: 2007, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "acquisition_fee_cents", default: 59500, null: false
    t.decimal "dealer_participation_sharing_percentage_24", default: "50.0", null: false
    t.integer "base_servicing_fee_cents", default: 500, null: false
    t.decimal "dealer_participation_sharing_percentage_36", default: "0.0", null: false
    t.decimal "dealer_participation_sharing_percentage_48", default: "0.0", null: false
    t.decimal "residual_reduction_percentage_24", default: "75.0", null: false
    t.decimal "residual_reduction_percentage_36", default: "70.0", null: false
    t.decimal "residual_reduction_percentage_48", default: "65.0", null: false
    t.decimal "residual_reduction_percentage_60", default: "65.0", null: false
    t.decimal "dealer_participation_sharing_percentage_60", default: "0.0", null: false
    t.integer "global_security_deposit", default: 0
    t.boolean "enable_global_security_deposit", default: false
    t.integer "make_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "audited_id"
    t.string "audited_type"
    t.integer "user_id"
    t.text "audited_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type"
    t.integer "parent_id"
    t.string "parent_type"
    t.index ["audited_id", "audited_type"], name: "index_audits_on_audited_id_and_audited_type"
    t.index ["user_id", "user_type"], name: "index_audits_on_user_id_and_user_type"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "bank_routing_numbers", id: :serial, force: :cascade do |t|
    t.string "routing_number"
    t.string "office_code"
    t.string "servicing_frb_number"
    t.string "record_type_code"
    t.date "change_date"
    t.string "new_routing_number"
    t.string "customer_name"
    t.string "address"
    t.string "city"
    t.string "state_code"
    t.string "zipcode"
    t.string "zipcode_extension"
    t.string "telephone_area_code"
    t.string "telephone_prefix_number"
    t.string "telephone_suffix_number"
    t.string "institution_status_code"
    t.string "data_view_code"
    t.string "filler"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routing_number"], name: "index_bank_routing_numbers_on_routing_number", unique: true
  end

  create_table "banners", force: :cascade do |t|
    t.string "headline"
    t.string "message"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.index ["created_by_admin_id"], name: "index_banners_on_created_by_admin_id"
    t.index ["updated_by_admin_id"], name: "index_banners_on_updated_by_admin_id"
  end

  create_table "blackbox_model_details", force: :cascade do |t|
    t.bigint "blackbox_model_id"
    t.integer "blackbox_tier", null: false
    t.integer "credit_score_greater_than", default: 0, null: false
    t.integer "credit_score_max", default: 0, null: false
    t.decimal "irr_value", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "maximum_fi_advance_percentage", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_advance_percentage", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "required_down_payment_percentage", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "security_deposit", default: 0, null: false
    t.boolean "enable_security_deposit", default: false, null: false
    t.integer "acquisition_fee_cents", default: 0, null: false
    t.decimal "payment_limit_percentage", precision: 4, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blackbox_model_id"], name: "index_blackbox_model_details_on_blackbox_model_id"
  end

  create_table "blackbox_models", force: :cascade do |t|
    t.string "blackbox_version", null: false
    t.date "model_date", null: false
    t.boolean "default_model", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_zip_begin"
    t.string "city_zip_end"
    t.string "geo_state"
    t.string "geo_county"
    t.string "geo_city"
    t.integer "us_state_id"
  end

  create_table "common_application_settings", force: :cascade do |t|
    t.string "company_term"
    t.string "underwriting_hours"
    t.string "funding_approval_checklist"
    t.string "power_of_attorney_template"
    t.string "illinois_power_of_attorney_template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deactivate_dealer_participation", default: false
    t.boolean "require_primary_email_address", default: false
    t.integer "scheduling_day", default: 15
    t.string "funding_request_form"
  end

  create_table "counties", force: :cascade do |t|
    t.integer "us_state_id"
    t.string "name"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geo_code_county", limit: 3
  end

  create_table "credit_report_bankruptcies", force: :cascade do |t|
    t.string "date_filed"
    t.integer "year_filed"
    t.integer "month_filed"
    t.string "bankruptcy_type"
    t.string "bankruptcy_status"
    t.string "date_status"
    t.bigint "credit_report_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_report_id"], name: "index_credit_report_bankruptcies_on_credit_report_id"
  end

  create_table "credit_report_repossessions", force: :cascade do |t|
    t.string "date_filed"
    t.integer "year_filed"
    t.integer "month_filed"
    t.string "creditor"
    t.string "notes"
    t.bigint "credit_report_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_report_id"], name: "index_credit_report_repossessions_on_credit_report_id"
  end

  create_table "credit_reports", force: :cascade do |t|
    t.string "status"
    t.string "upload"
    t.string "identifier"
    t.boolean "visible_to_dealers"
    t.bigint "lessee_id"
    t.jsonb "record_errors", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sidekiq_retry_count", default: 0
    t.datetime "effective_date"
    t.datetime "end_date"
    t.integer "credit_score"
    t.integer "credit_score_equifax"
    t.integer "credit_score_experian"
    t.integer "credit_score_transunion"
    t.float "credit_score_average"
    t.string "credco_xml"
    t.integer "credco_request_control", limit: 2
    t.string "credco_request_event_source"
    t.index ["lessee_id"], name: "index_credit_reports_on_lessee_id"
  end

  create_table "credit_tiers", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.integer "make_id"
    t.string "description"
    t.decimal "irr_value", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "maximum_fi_advance_percentage", precision: 4, scale: 2, default: "0.0"
    t.decimal "maximum_advance_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "required_down_payment_percentage", precision: 4, scale: 2, default: "0.0"
    t.integer "security_deposit", default: 0, null: false
    t.boolean "enable_security_deposit", default: false
    t.integer "acquisition_fee_cents", default: 99500
    t.date "effective_date"
    t.date "end_date"
    t.decimal "payment_limit_percentage", precision: 4, scale: 2, default: "0.0"
    t.bigint "model_group_id"
    t.index ["make_id"], name: "index_credit_tiers_on_make_id"
    t.index ["model_group_id"], name: "index_credit_tiers_on_model_group_id"
  end

  create_table "curr_date", id: false, force: :cascade do |t|
    t.string "value", limit: 8
  end

  create_table "dealer_representatives", force: :cascade do |t|
    t.string "email"
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.bigint "admin_user_id"
    t.boolean "is_active", default: true
    t.index ["admin_user_id"], name: "index_dealer_representatives_on_admin_user_id"
    t.index ["dealership_id"], name: "index_dealer_representatives_on_dealership_id"
  end

  create_table "dealer_representatives_dealerships", force: :cascade do |t|
    t.integer "dealership_id"
    t.integer "dealer_representative_id"
    t.index ["dealer_representative_id", "dealership_id"], name: "dealer_rep_idx3"
    t.index ["dealer_representative_id"], name: "dealer_rep_idx1"
    t.index ["dealership_id"], name: "dealer_rep_idx2"
  end

  create_table "dealer_security_roles", force: :cascade do |t|
    t.bigint "dealer_id"
    t.bigint "security_role_id"
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_admin_id"], name: "index_dealer_security_roles_created_by_on_admin_user_id"
    t.index ["dealer_id"], name: "index_dealer_security_roles_on_dealer_id"
    t.index ["security_role_id"], name: "index_dealer_security_roles_on_security_role_id"
    t.index ["updated_by_admin_id"], name: "index_dealer_security_roles_updated_by_on_admin_user_id"
  end

  create_table "dealers", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dealership_id"
    t.datetime "first_sign_in_at"
    t.boolean "is_disabled", default: false, null: false
    t.boolean "notify_credit_decision", default: true
    t.boolean "notify_funding_decision", default: true
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "auth_token"
    t.datetime "auth_token_created_at"
    t.datetime "password_changed_at"
    t.string "unique_session_id", limit: 20
    t.index ["auth_token", "auth_token_created_at"], name: "index_dealers_on_auth_token_and_auth_token_created_at"
    t.index ["dealership_id"], name: "index_dealers_on_dealership_id"
    t.index ["email"], name: "index_dealers_on_email", unique: true
    t.index ["password_changed_at"], name: "index_dealers_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_dealers_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_dealers_on_unlock_token", unique: true
  end

  create_table "dealership_approval_events", force: :cascade do |t|
    t.boolean "approved", default: false
    t.bigint "admin_user_id"
    t.bigint "dealership_approval_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comments"
    t.index ["admin_user_id"], name: "index_dealership_approval_events_on_admin_user_id"
    t.index ["dealership_approval_id"], name: "index_dealership_approval_events_on_dealership_approval_id"
  end

  create_table "dealership_approval_types", force: :cascade do |t|
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dealership_approvals", force: :cascade do |t|
    t.bigint "dealership_id"
    t.bigint "dealership_approval_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dealership_approval_type_id"], name: "index_dealership_approvals_on_dealership_approval_type_id"
    t.index ["dealership_id"], name: "index_dealership_approvals_on_dealership_id"
  end

  create_table "dealership_attachments", force: :cascade do |t|
    t.string "upload"
    t.bigint "dealership_id"
    t.bigint "admin_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_dealership_attachments_on_admin_user_id"
    t.index ["dealership_id"], name: "index_dealership_attachments_on_dealership_id"
  end

  create_table "dealerships", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "primary_contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", null: false
    t.boolean "franchised"
    t.boolean "franchised_new_makes"
    t.string "legal_corporate_entity"
    t.string "dealer_group"
    t.boolean "active"
    t.integer "address_id"
    t.date "agreement_signed_on"
    t.string "executed_by_name"
    t.string "executed_by_title"
    t.date "executed_by_slc_on"
    t.date "los_access_date"
    t.text "notes"
    t.boolean "use_experian", default: true, null: false
    t.boolean "use_equifax", default: false, null: false
    t.boolean "use_transunion", default: true, null: false
    t.integer "access_id"
    t.string "bank_name"
    t.string "account_number"
    t.string "routing_number"
    t.integer "account_type"
    t.integer "security_deposit", default: 0, null: false
    t.boolean "enable_security_deposit", default: false
    t.boolean "can_submit", default: false
    t.boolean "can_see_banner", default: true
    t.integer "deal_fee_cents", default: 0, null: false
    t.integer "year_incorporated_or_control_year"
    t.integer "years_in_business"
    t.boolean "previously_approved_dealership", default: false
    t.integer "previous_transactions_submitted"
    t.integer "previous_transactions_closed"
    t.decimal "previous_default_rate", precision: 30, scale: 2
    t.bigint "remit_to_dealer_calculation_id"
    t.string "employer_identification_number", limit: 9
    t.boolean "secretary_state_valid"
    t.string "owner_first_name"
    t.string "owner_last_name"
    t.bigint "owner_address_id"
    t.string "business_description"
    t.string "notification_email", limit: 255
    t.string "dealer_license_number"
    t.date "license_expiration_date"
    t.decimal "pct_ownership", precision: 30, scale: 2
    t.index ["address_id"], name: "index_dealerships_on_address_id"
    t.index ["owner_address_id"], name: "index_dealerships_ownership_address_id_on_address_id"
    t.index ["remit_to_dealer_calculation_id"], name: "index_dealerships_on_remit_to_dealer_calculation_id"
  end

  create_table "decline_reason_types", force: :cascade do |t|
    t.string "decline_reason_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "decline_reasons", force: :cascade do |t|
    t.string "description"
    t.bigint "lease_application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_application_id"], name: "index_decline_reasons_on_lease_application_id"
  end

  create_table "departments", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docusign_histories", force: :cascade do |t|
    t.bigint "docusign_summary_id"
    t.string "user_name", null: false
    t.integer "user_role", default: 0, null: false
    t.string "user_email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_status"
    t.index ["docusign_summary_id"], name: "index_docusign_histories_on_docusign_summary_id"
  end

  create_table "docusign_summaries", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.string "envelope_id", null: false
    t.integer "envelope_status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_application_id"], name: "index_docusign_summaries_on_lease_application_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "template"
    t.boolean "enable_template", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "employment_statuses", force: :cascade do |t|
    t.integer "employment_status_index"
    t.string "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "file_attachment_types", force: :cascade do |t|
    t.string "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "funding_delay_reasons", force: :cascade do |t|
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "funding_delays", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.bigint "funding_delay_reason_id"
    t.text "notes"
    t.string "status", default: "Required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["funding_delay_reason_id"], name: "funding_delay_reason_idx"
    t.index ["lease_application_id", "funding_delay_reason_id"], name: "funding_delays_unique_index"
    t.index ["lease_application_id"], name: "lease_application_id_idx"
  end

  create_table "funding_request_histories", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_application_id"], name: "index_funding_request_histories_on_lease_application_id"
  end

  create_table "inbound_contacts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.text "message"
    t.string "dealership_name"
    t.integer "kind"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.boolean "existing_user"
  end

  create_table "income_frequencies", force: :cascade do |t|
    t.string "income_frequency_name"
  end

  create_table "income_verification_attachments", force: :cascade do |t|
    t.bigint "income_verification_id"
    t.bigint "lease_application_attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["income_verification_id"], name: "index_iva_on_income_verification_id"
    t.index ["lease_application_attachment_id"], name: "index_iva_on_lease_application_attachment_id"
  end

  create_table "income_verification_types", force: :cascade do |t|
    t.string "income_verification_name"
  end

  create_table "income_verifications", force: :cascade do |t|
    t.bigint "lessee_id"
    t.bigint "income_verification_type_id"
    t.string "employer_client"
    t.integer "gross_income_cents"
    t.bigint "income_frequency_id"
    t.bigint "lease_application_attachment_id"
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "other_type"
    t.index ["created_by_admin_id"], name: "index_income_verifications_created_by_on_admin_user_id"
    t.index ["income_frequency_id"], name: "index_income_verifications_on_income_frequency_id"
    t.index ["income_verification_type_id"], name: "index_income_verifications_on_income_verification_type_id"
    t.index ["lease_application_attachment_id"], name: "index_income_verifications_on_lease_application_attachment_id"
    t.index ["lessee_id"], name: "index_income_verifications_on_lessee_id"
    t.index ["updated_by_admin_id"], name: "index_income_verifications_updated_by_on_admin_user_id"
  end

  create_table "insurance_companies", force: :cascade do |t|
    t.string "company_name"
    t.string "company_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "insurances", force: :cascade do |t|
    t.string "company_name"
    t.string "bodily_injury_per_person"
    t.string "bodily_injury_per_occurrence"
    t.string "comprehensive"
    t.string "collision"
    t.string "property_damage"
    t.date "effective_date"
    t.date "expiration_date"
    t.boolean "loss_payee"
    t.boolean "additional_insured"
    t.bigint "lease_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "insurance_company_id"
    t.string "policy_number"
    t.index ["insurance_company_id"], name: "index_insurances_on_insurance_company_id"
    t.index ["lease_application_id"], name: "index_insurances_on_lease_application_id"
  end

  create_table "inventory_statuses", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lease_application_attachment_meta_data", force: :cascade do |t|
    t.bigint "lease_application_id", null: false
    t.bigint "file_attachment_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "lease_application_attachment_id", null: false
    t.index ["file_attachment_type_id"], name: "index_attachment_meta_data_on_file_attachment_type_id"
    t.index ["lease_application_attachment_id"], name: "index_attachment_meta_data_on_lease_application_attachment_id"
    t.index ["lease_application_id"], name: "index_attachment_meta_data_on_lease_application_id"
  end

  create_table "lease_application_attachments", id: :serial, force: :cascade do |t|
    t.integer "lease_application_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_to_dealers", default: true, null: false
    t.string "description"
    t.integer "lessee_id"
    t.string "merge_report_identifier"
    t.string "upload"
    t.string "uploader_type"
    t.bigint "uploader_id"
    t.index ["lease_application_id"], name: "index_lease_application_attachments_on_lease_application_id"
    t.index ["lessee_id"], name: "index_lease_application_attachments_on_lessee_id"
    t.index ["uploader_id", "uploader_type"], name: "lease_app_uploader_idx"
  end

  create_table "lease_application_blackbox_adverse_reasons", force: :cascade do |t|
    t.bigint "lease_application_blackbox_request_id"
    t.string "reason_code"
    t.string "description"
    t.string "suggested_correction"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_application_blackbox_request_id"], name: "index_adverse_reasons_on_lease_app_blackbox_req"
  end

  create_table "lease_application_blackbox_employment_searches", force: :cascade do |t|
    t.bigint "lease_application_blackbox_request_id"
    t.string "employer_name"
    t.string "employee_first_name"
    t.string "employee_last_name"
    t.text "employee_encrypted_ssn"
    t.string "employment_status"
    t.date "employment_start_date"
    t.integer "total_months_with_employer"
    t.date "termination_date"
    t.string "position_title"
    t.integer "rate_of_pay_cents"
    t.integer "annualized_income_cents"
    t.string "pay_frequency"
    t.string "pay_period_frequency"
    t.integer "average_hours_worked_per_pay_period"
    t.jsonb "compensation_history", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "employee_middle_name"
    t.index ["lease_application_blackbox_request_id"], name: "index_blackbox_employment_searches_on_blackbox_request_id"
  end

  create_table "lease_application_blackbox_errors", force: :cascade do |t|
    t.bigint "lease_application_blackbox_request_id"
    t.integer "error_code"
    t.string "name"
    t.string "message"
    t.jsonb "failure_conditional"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_application_blackbox_request_id"], name: "index_blackbox_errors_on_blackbox_request_id"
  end

  create_table "lease_application_blackbox_requests", force: :cascade do |t|
    t.integer "lease_application_id"
    t.string "leadrouter_response"
    t.float "leadrouter_credit_score"
    t.string "leadrouter_suggested_corrections"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "leadrouter_lead_id_int"
    t.string "leadrouter_request_body"
    t.bigint "lessee_id"
    t.uuid "leadrouter_lead_id"
    t.string "blackbox_endpoint"
    t.integer "reject_stage"
    t.integer "request_control", limit: 2
    t.string "request_event_source"
    t.index ["lessee_id"], name: "index_lease_application_blackbox_requests_on_lessee_id"
  end

  create_table "lease_application_blackbox_tlo_person_search_addresses", force: :cascade do |t|
    t.date "date_first_seen"
    t.date "date_last_seen"
    t.string "street_address_1"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "county"
    t.string "zip_plus_four"
    t.string "building_name"
    t.string "description"
    t.string "subdivision_name"
    t.bigint "lease_application_blackbox_request_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_application_blackbox_request_id"], name: "blackbox_tlo_person_search_addresses_req"
  end

  create_table "lease_application_credcos", force: :cascade do |t|
    t.integer "lease_application_id"
    t.string "credco_xml"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "borrower_id_score"
    t.string "revolving_credit_available"
    t.string "open_auto_monthly_payment"
  end

  create_table "lease_application_datax_requests", force: :cascade do |t|
    t.integer "lease_application_id"
    t.string "leadrouter_request_body"
    t.string "leadrouter_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lease_application_gps_units", force: :cascade do |t|
    t.bigint "lease_application_id", null: false
    t.string "gps_serial_number", null: false
    t.boolean "active", default: true, null: false
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_admin_id"], name: "index_gps_units_created_by_on_admin_user_id"
    t.index ["lease_application_id"], name: "index_gps_units_on_lease_application_id"
    t.index ["updated_by_admin_id"], name: "index_gps_units_updated_by_on_admin_user_id"
  end

  create_table "lease_application_payment_limits", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.bigint "credit_tier_id"
    t.integer "proven_monthly_income_cents"
    t.integer "max_allowable_payment_cents"
    t.integer "variance_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_monthly_payment_cents", default: 0, null: false
    t.integer "override_max_allowable_payment_cents"
    t.integer "override_variance_cents"
    t.index ["credit_tier_id"], name: "index_payment_limits_on_credit_tier_id"
    t.index ["lease_application_id"], name: "index_payment_limits_on_lease_application_id"
  end

  create_table "lease_application_recommended_blackbox_tiers", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.bigint "blackbox_model_detail_id"
    t.integer "lessee_lease_application_blackbox_request_id"
    t.integer "colessee_lease_application_blackbox_request_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blackbox_model_detail_id"], name: "index_recommended_blackbox_tiers_on_blackbox_model_detail_id"
    t.index ["lease_application_id"], name: "index_recommended_blackbox_tiers_on_lease_application_id"
  end

  create_table "lease_application_recommended_credit_tiers", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.bigint "credit_tier_id"
    t.integer "lessee_credit_report_id"
    t.integer "colessee_credit_report_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_tier_id"], name: "index_recommended_credit_tiers_on_credit_tier_id"
    t.index ["lease_application_id"], name: "index_recommended_credit_tiers_on_lease_application_id"
  end

  create_table "lease_application_stipulations", id: :serial, force: :cascade do |t|
    t.integer "lease_application_id", null: false
    t.integer "stipulation_id", null: false
    t.string "status", default: "Required", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lease_application_attachment_id"
    t.text "notes"
    t.integer "monthly_payment_limit_cents", default: 0, null: false
    t.index ["lease_application_attachment_id"], name: "lease_application_stipulations_attachment"
    t.index ["lease_application_id", "stipulation_id"], name: "index_lease_application_stipulations_uniqueness", unique: true
    t.index ["lease_application_id"], name: "index_lease_application_stipulations_on_lease_application_id"
    t.index ["stipulation_id"], name: "index_lease_application_stipulations_on_stipulation_id"
  end

  create_table "lease_application_underwriting_reviews", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.bigint "admin_user_id"
    t.bigint "workflow_status_id"
    t.string "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_la_underwriting_reviews_on_admin_user_id"
    t.index ["lease_application_id"], name: "index_la_underwriting_reviews_on_lease_application_id"
    t.index ["workflow_status_id"], name: "index_la_underwriting_reviews_on_workflow_status_id"
  end

  create_table "lease_application_welcome_calls", force: :cascade do |t|
    t.integer "lease_application_id"
    t.integer "welcome_call_result_id"
    t.integer "welcome_call_type_id"
    t.integer "welcome_call_status_id"
    t.integer "welcome_call_representative_type_id"
    t.integer "admin_id"
    t.datetime "due_date"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lease_applications", id: :serial, force: :cascade do |t|
    t.integer "lessee_id"
    t.integer "colessee_id"
    t.integer "dealer_id"
    t.integer "lease_calculator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_status", default: "no_documents", null: false
    t.string "credit_status", default: "unsubmitted", null: false
    t.date "submitted_at"
    t.boolean "expired", default: false
    t.string "application_identifier"
    t.date "documents_issued_date"
    t.integer "dealership_id"
    t.datetime "lease_package_received_date"
    t.datetime "credit_decision_date"
    t.date "funding_delay_on"
    t.date "funding_approved_on"
    t.date "funded_on"
    t.date "first_payment_date"
    t.string "payment_aba_routing_number"
    t.string "payment_account_number"
    t.string "payment_bank_name"
    t.integer "payment_account_type", default: 0
    t.integer "payment_frequency"
    t.integer "payment_first_day"
    t.integer "payment_second_day"
    t.date "second_payment_date"
    t.string "promotion_name"
    t.float "promotion_value"
    t.boolean "is_dealership_subject_to_clawback", default: false
    t.decimal "this_deal_dealership_clawback_amount", precision: 30, scale: 2
    t.decimal "after_this_deal_dealership_clawback_amount", precision: 30, scale: 2
    t.bigint "city_id"
    t.string "vehicle_possession"
    t.string "payment_account_holder", default: "Lessee"
    t.datetime "welcome_call_due_date"
    t.bigint "department_id"
    t.boolean "is_verification_call_completed", default: false
    t.boolean "is_exported_to_access_db", default: false
    t.integer "requested_by"
    t.integer "approved_by"
    t.string "prenote_status"
    t.bigint "mail_carrier_id"
    t.bigint "workflow_status_id"
    t.boolean "application_disclosure_agreement", default: false
    t.inet "submitting_ip_address"
    t.boolean "archived", default: false
    t.string "the_reviewer"
    t.string "the_approver"
    t.date "documents_requested_date"
    t.string "colessee_payment_aba_routing_number"
    t.string "colessee_payment_account_number"
    t.string "colessee_payment_bank_name"
    t.integer "colessee_payment_account_type", default: 0
    t.string "colessee_account_joint_to_lessee"
    t.index ["application_identifier"], name: "index_lease_applications_on_application_identifier", unique: true, where: "(application_identifier IS NOT NULL)"
    t.index ["city_id"], name: "index_lease_applications_on_city_id"
    t.index ["colessee_id"], name: "index_lease_applications_on_colessee_id"
    t.index ["dealer_id"], name: "index_lease_applications_on_dealer_id"
    t.index ["dealership_id"], name: "index_lease_applications_on_dealership_id"
    t.index ["department_id"], name: "index_lease_applications_on_department_id"
    t.index ["lease_calculator_id"], name: "index_lease_applications_on_lease_calculator_id"
    t.index ["lessee_id"], name: "index_lease_applications_on_lessee_id"
    t.index ["mail_carrier_id"], name: "index_lease_applications_on_mail_carrier_id"
    t.index ["workflow_status_id"], name: "index_lease_applications_on_workflow_status_id"
  end

  create_table "lease_calculators", id: :serial, force: :cascade do |t|
    t.string "asset_make"
    t.string "asset_model"
    t.integer "asset_year"
    t.integer "condition"
    t.string "mileage_tier"
    t.string "credit_tier"
    t.integer "term"
    t.string "tax_jurisdiction"
    t.string "us_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nada_retail_value_cents", default: 0, null: false
    t.integer "customer_purchase_option_cents", default: 0, null: false
    t.integer "dealer_sales_price_cents", default: 0, null: false
    t.integer "dealer_freight_and_setup_cents", default: 0, null: false
    t.integer "total_dealer_price_cents", default: 0, null: false
    t.integer "upfront_tax_cents", default: 0, null: false
    t.integer "title_license_and_lien_fee_cents", default: 0, null: false
    t.integer "dealer_documentation_fee_cents", default: 0, null: false
    t.integer "guaranteed_auto_protection_cost_cents", default: 0, null: false
    t.integer "prepaid_maintenance_cost_cents", default: 0, null: false
    t.integer "extended_service_contract_cost_cents", default: 0, null: false
    t.integer "tire_and_wheel_contract_cost_cents", default: 0, null: false
    t.integer "fi_maximum_total_cents", default: 0, null: false
    t.integer "total_sales_price_cents", default: 0, null: false
    t.integer "gross_trade_in_allowance_cents", default: 0, null: false
    t.integer "trade_in_payoff_cents", default: 0, null: false
    t.integer "net_trade_in_allowance_cents", default: 0, null: false
    t.integer "rebates_and_noncash_credits_cents", default: 0, null: false
    t.integer "cash_down_payment_cents", default: 0, null: false
    t.integer "cash_down_minimum_cents", default: 0, null: false
    t.integer "acquisition_fee_cents", default: 0, null: false
    t.integer "adjusted_capitalized_cost_cents", default: 0, null: false
    t.integer "base_monthly_payment_cents", default: 0, null: false
    t.integer "monthly_sales_tax_cents", default: 0, null: false
    t.integer "total_monthly_payment_cents", default: 0, null: false
    t.integer "refundable_security_deposit_cents", default: 0, null: false
    t.integer "total_cash_at_signing_cents", default: 0, null: false
    t.integer "minimum_reserve_cents", default: 20000, null: false
    t.integer "dealer_reserve_cents", default: 0, null: false
    t.integer "monthly_depreciation_charge_cents", default: 0, null: false
    t.integer "monthly_lease_charge_cents", default: 0, null: false
    t.integer "remit_to_dealer_cents", default: 0, null: false
    t.decimal "dealer_participation_markup", precision: 3, scale: 2, default: "0.0"
    t.integer "servicing_fee_cents", default: 0, null: false
    t.integer "backend_max_advance_cents", default: 0, null: false
    t.integer "frontend_max_advance_cents", default: 0, null: false
    t.integer "backend_total_cents", default: 0, null: false
    t.integer "frontend_total_cents", default: 0, null: false
    t.integer "ga_tavt_value_cents", default: 0, null: false
    t.integer "pre_tax_payments_sum_cents", default: 0, null: false
    t.integer "original_msrp_cents", default: 0, null: false
    t.integer "nada_rough_value_cents", default: 0, null: false
    t.string "new_used"
    t.string "notes"
    t.integer "acc_less_fi_less_af_cents", default: 0, null: false
    t.bigint "credit_tier_id"
    t.integer "dealer_shortfund_amount_cents", default: 0, null: false
    t.integer "remit_to_dealer_less_shortfund_cents", default: 0, null: false
    t.bigint "model_year_id"
    t.string "asset_vin"
    t.integer "gps_cost_cents", default: 0, null: false
    t.integer "gross_capitalized_cost_cents", default: 0, null: false
    t.index ["credit_tier_id"], name: "index_lease_calculators_on_credit_tier_id"
    t.index ["model_year_id"], name: "index_lease_calculators_on_model_year_id"
  end

  create_table "lease_document_requests", id: :serial, force: :cascade do |t|
    t.integer "lease_application_id"
    t.string "asset_make"
    t.string "asset_model"
    t.integer "asset_year"
    t.string "asset_vin"
    t.string "asset_color"
    t.string "exact_odometer_mileage"
    t.string "trade_in_make"
    t.string "trade_in_model"
    t.string "trade_in_year"
    t.date "delivery_date"
    t.integer "gap_contract_term", default: 0
    t.integer "service_contract_term", default: 0
    t.integer "ppm_contract_term", default: 0
    t.integer "tire_contract_term", default: 0
    t.string "equipped_with"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manual_vin_verification"
    t.bigint "model_year_id"
    t.index ["lease_application_id"], name: "index_lease_document_requests_on_lease_application_id"
    t.index ["model_year_id"], name: "index_lease_document_requests_on_model_year_id"
  end

  create_table "lease_management_system_document_statuses", force: :cascade do |t|
    t.string "description", null: false
    t.string "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lease_management_systems", force: :cascade do |t|
    t.string "api_destination", null: false
    t.boolean "send_leases_to_lms", default: false, null: false
    t.bigint "lease_management_system_document_status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lease_management_system_document_status_id"], name: "lms_on_lms_document_status_id"
  end

  create_table "lease_package_templates", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "lease_package_template"
    t.integer "document_type", null: false
    t.string "us_states", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "enabled", default: true, null: false
    t.index ["name"], name: "index_lease_package_templates_on_name", unique: true
  end

  create_table "lease_validations", id: :serial, force: :cascade do |t|
    t.integer "lease_application_id"
    t.string "validatable_type"
    t.integer "validatable_id"
    t.string "type"
    t.string "status"
    t.string "original_value"
    t.string "revised_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "validation_response"
    t.jsonb "npa_validation_response", default: {}, null: false
    t.index ["id", "type"], name: "index_lease_validations_on_id_and_type"
    t.index ["lease_application_id"], name: "index_lease_validations_on_lease_application_id"
    t.index ["validatable_type", "validatable_id"], name: "index_lease_validations_on_validatable_type_and_validatable_id"
  end

  create_table "lessee_recommended_blackbox_tiers", force: :cascade do |t|
    t.bigint "lessee_id"
    t.bigint "blackbox_model_detail_id"
    t.bigint "lease_application_blackbox_request_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blackbox_model_detail_id"], name: "lrbt_on_blackbox_model_detail_id"
    t.index ["lease_application_blackbox_request_id"], name: "lrbt_on_lease_application_blackbox_request_id"
    t.index ["lessee_id"], name: "index_lessee_recommended_blackbox_tiers_on_lessee_id"
  end

  create_table "lessees", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "suffix"
    t.string "encrypted_ssn"
    t.date "date_of_birth"
    t.string "mobile_phone_number"
    t.string "home_phone_number"
    t.string "drivers_license_id_number"
    t.string "drivers_license_state"
    t.string "email_address"
    t.string "employment_details"
    t.integer "home_address_id"
    t.integer "mailing_address_id"
    t.integer "employment_address_id"
    t.string "encrypted_ssn_iv"
    t.integer "at_address_years"
    t.integer "at_address_months"
    t.decimal "monthly_mortgage"
    t.integer "home_ownership"
    t.date "drivers_licence_expires_at"
    t.string "employer_name"
    t.integer "time_at_employer_years"
    t.integer "time_at_employer_months"
    t.string "job_title"
    t.integer "employment_status"
    t.string "employer_phone_number"
    t.decimal "gross_monthly_income"
    t.decimal "other_monthly_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "highest_fico_score"
    t.bigint "deleted_from_lease_application_id"
    t.string "mobile_phone_number_line"
    t.string "mobile_phone_number_carrier"
    t.string "home_phone_number_line"
    t.string "home_phone_number_carrier"
    t.string "employer_phone_number_line"
    t.string "employer_phone_number_carrier"
    t.text "ssn"
    t.decimal "proven_monthly_income"
    t.boolean "first_time_rider"
    t.boolean "motorcycle_licence"
    t.boolean "is_driving", default: false
    t.bigint "relationship_to_lessee_id"
    t.datetime "deleted_at"
    t.string "lessee_and_colessee_relationship"
    t.index ["deleted_from_lease_application_id"], name: "index_lessees_on_deleted_from_lease_application_id"
    t.index ["employment_address_id"], name: "index_lessees_on_employment_address_id"
    t.index ["home_address_id"], name: "index_lessees_on_home_address_id"
    t.index ["mailing_address_id"], name: "index_lessees_on_mailing_address_id"
    t.index ["relationship_to_lessee_id"], name: "index_lessees_on_relationship_to_lessee_id"
  end

  create_table "lpc_form_code_lookups", force: :cascade do |t|
    t.integer "lpc_form_code_id"
    t.string "lpc_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "us_state_id"
  end

  create_table "lpc_form_codes", force: :cascade do |t|
    t.integer "lpc_form_code_id"
    t.string "lpc_form_code_abbrev"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mail_carriers", force: :cascade do |t|
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_index"
  end

  create_table "makes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "vin_starts_with"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lms_manf", limit: 10
    t.boolean "nada_enabled", default: false
    t.boolean "active", default: true
  end

  create_table "mileage_tiers", id: :serial, force: :cascade do |t|
    t.integer "upper"
    t.integer "lower"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "maximum_frontend_advance_haircut_0", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_1", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_2", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_3", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_4", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_5", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_6", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_7", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_8", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_9", precision: 4, scale: 2, default: "0.0", null: false
    t.string "custom_label"
    t.integer "position"
    t.decimal "maximum_frontend_advance_haircut_10", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_11", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_12", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_13", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "maximum_frontend_advance_haircut_14", precision: 4, scale: 2, default: "0.0", null: false
  end

  create_table "model_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "make_id"
    t.integer "minimum_dealer_participation_cents", default: 0, null: false
    t.decimal "residual_reduction_percentage", default: "0.0", null: false
    t.integer "maximum_term_length", default: 60, null: false
    t.integer "backend_advance_minimum_cents", default: 0, null: false
    t.decimal "maximum_haircut_0", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_1", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_2", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_3", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_4", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_5", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_6", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_7", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_8", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_9", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_10", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_11", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_12", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_13", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_14", precision: 4, scale: 2, default: "1.0", null: false
    t.integer "sort_index"
    t.jsonb "maximum_term_length_per_year"
    t.index ["make_id"], name: "index_model_groups_on_make_id"
  end

  create_table "model_years", id: :serial, force: :cascade do |t|
    t.integer "original_msrp_cents", default: 0, null: false
    t.integer "nada_avg_retail_cents", default: 0, null: false
    t.integer "nada_rough_cents", default: 0, null: false
    t.string "name"
    t.integer "year"
    t.integer "residual_24_cents", default: 0, null: false
    t.integer "residual_36_cents", default: 0, null: false
    t.integer "residual_48_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "model_group_id"
    t.integer "residual_60_cents", default: 0, null: false
    t.decimal "maximum_haircut_0", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_1", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_2", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_3", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_4", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_5", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_6", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_7", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_8", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_9", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_10", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_11", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_12", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_13", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "maximum_haircut_14", precision: 4, scale: 2, default: "1.0", null: false
    t.date "start_date", default: "2019-05-01"
    t.date "end_date", default: "2999-12-31"
    t.string "nada_model_number"
    t.boolean "police_bike", default: false, null: false
    t.string "nada_volume_number"
    t.boolean "slc_model_group_mapping_flag", default: true
    t.string "nada_model_group_name"
    t.integer "maximum_term_length"
    t.index ["model_group_id"], name: "index_model_years_on_model_group_id"
  end

  create_table "nacha_noc_codes", force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_nacha_noc_codes_on_code"
  end

  create_table "nacha_return_codes", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nada_dummy_bikes", force: :cascade do |t|
    t.string "year"
    t.string "model_group_name"
    t.string "bike_model_name"
    t.string "nada_rough_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "make_id"
  end

  create_table "negative_pays", force: :cascade do |t|
    t.string "payment_bank_name"
    t.string "payment_account_type"
    t.string "payment_account_number"
    t.string "payment_aba_routing_number"
    t.string "request"
    t.string "response"
    t.bigint "lease_application_id"
    t.bigint "lessee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_application_id"], name: "index_negative_pays_on_lease_application_id"
    t.index ["lessee_id"], name: "index_negative_pays_on_lessee_id"
  end

  create_table "notification_attachments", force: :cascade do |t|
    t.bigint "notification_id"
    t.string "description"
    t.string "upload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_attachments_on_notification_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "read_at"
    t.integer "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "notification_mode", null: false
    t.string "notification_content", null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.index ["notifiable_id", "notifiable_type"], name: "index_notifications_on_notifiable_id_and_notifiable_type"
    t.index ["recipient_id", "recipient_type", "notification_mode"], name: "notifications_recipient_and_mode_idx"
    t.index ["recipient_id", "recipient_type"], name: "notifications_recipient_idx"
  end

  create_table "old_passwords", id: :serial, force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.datetime "created_at"
    t.string "password_salt"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "online_funding_approval_checklists", force: :cascade do |t|
    t.boolean "no_markups_or_erasure", default: false
    t.boolean "lease_agreement_signed", default: false
    t.boolean "motorcycle_condition_reported", default: false
    t.boolean "credit_application_signed", default: false
    t.boolean "four_references_present", default: false
    t.boolean "valid_dl", default: false
    t.boolean "ach_form_completed", default: false
    t.boolean "insurance_requirements", default: false
    t.boolean "valid_email_address", default: false
    t.boolean "registration_documents_with_slc", default: false
    t.boolean "ods_signed_and_dated", default: false
    t.boolean "proof_of_amounts_due", default: false
    t.boolean "documentation_to_satisfy", default: false
    t.boolean "warranty_products_purchased", default: false
    t.boolean "signed_bos", default: false
    t.boolean "package_reviewed", default: false
    t.datetime "package_reviewed_on"
    t.integer "reviewed_by"
    t.bigint "lease_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_url"
    t.index ["lease_application_id"], name: "index_lease_applications_on_funding_approval_checklist_id"
  end

  create_table "online_verification_call_checklists", force: :cascade do |t|
    t.bigint "lease_application_id"
    t.boolean "lessee_available_to_speak"
    t.boolean "lessee_social_security_confirm"
    t.boolean "lessee_date_of_birth_confirm"
    t.boolean "lessee_street_address_confirm"
    t.string "lessee_email"
    t.string "lessee_best_phone_number"
    t.boolean "lessee_can_receive_text_messages"
    t.boolean "lease_term_confirm"
    t.boolean "monthly_payment_confirm"
    t.boolean "payment_frequency_confirm"
    t.integer "payment_frequency_type", limit: 2
    t.boolean "first_payment_date_confirm"
    t.boolean "second_payment_date_confirm"
    t.boolean "due_dates_match_lessee_pay_date"
    t.integer "lessee_reported_year"
    t.string "lessee_reported_make"
    t.string "lessee_reported_model"
    t.boolean "lessee_has_test_driven_bike"
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "completed_by_id"
    t.integer "vehicle_mileage"
    t.string "vin_number_last_six"
    t.string "vehicle_color"
    t.boolean "bike_in_working_order"
    t.boolean "lessee_confirm_residual_value"
    t.string "lessee_available_to_speak_comment"
    t.string "lessee_social_security_confirm_comment"
    t.string "lessee_date_of_birth_confirm_comment"
    t.string "lessee_street_address_confirm_comment"
    t.string "lessee_can_receive_text_messages_comment"
    t.string "lease_term_confirm_comment"
    t.string "monthly_payment_confirm_comment"
    t.string "payment_frequency_confirm_comment"
    t.string "first_payment_date_confirm_comment"
    t.string "second_payment_date_confirm_comment"
    t.string "due_dates_match_lessee_pay_date_comment"
    t.string "lessee_has_test_driven_bike_comment"
    t.string "bike_in_working_order_comment"
    t.boolean "issue", default: false
    t.string "lessee_confirm_residual_value_comment"
    t.index ["completed_by_id"], name: "index_online_verification_call_checklists_on_completed_by_id"
    t.index ["lease_application_id"], name: "index_ovc_checklists_on_lease_application"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "security_role_id"
    t.bigint "resource_id", null: false
    t.bigint "action_id", null: false
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action_id"], name: "index_permissions_on_action_id"
    t.index ["created_by_admin_id"], name: "index_permissions_created_by_on_admin_user_id"
    t.index ["resource_id"], name: "index_permissions_on_resource_id"
    t.index ["security_role_id"], name: "index_permissions_on_security_role_id"
    t.index ["updated_by_admin_id"], name: "index_permissions_updated_by_on_admin_user_id"
  end

  create_table "police_bike_rules", force: :cascade do |t|
    t.integer "proxy_model_make"
    t.string "proxy_model_name"
    t.integer "new_model_make"
    t.string "new_model_name"
    t.decimal "proxy_rough_value_percent", precision: 10, scale: 2
    t.decimal "proxy_retail_value_percent", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "starting_proxy_year", default: 2017, null: false
  end

  create_table "prenotes", force: :cascade do |t|
    t.string "response"
    t.bigint "lease_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "usio_confirmation_number"
    t.string "usio_status"
    t.string "usio_message"
    t.jsonb "usio_transaction_response", default: {}, null: false
    t.string "prenote_message"
    t.string "prenote_status"
    t.boolean "email_notification_sent", default: false
    t.index ["lease_application_id"], name: "index_prenotes_on_lease_application_id"
  end

  create_table "recommended_credit_tiers", force: :cascade do |t|
    t.integer "lessee_id"
    t.integer "credit_tier_id"
    t.integer "credit_report_id"
    t.integer "recommended_credit_tier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lease_application_blackbox_request_id"
  end

  create_table "references", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lease_application_id"
    t.string "city"
    t.string "state"
    t.string "phone_number_line"
    t.string "phone_number_carrier"
    t.index ["lease_application_id"], name: "index_references_on_lease_application_id"
  end

  create_table "related_applications", force: :cascade do |t|
    t.integer "origin_application_id", null: false
    t.integer "related_application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["origin_application_id"], name: "index_related_applications_on_origin_application_id"
    t.index ["related_application_id"], name: "index_related_applications_on_related_application_id"
  end

  create_table "relationship_to_lessees", force: :cascade do |t|
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "remit_to_dealer_calculations", force: :cascade do |t|
    t.string "calculation_name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "remote_check_return_codes", force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_remote_check_return_codes_on_code"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_active", default: true, null: false
    t.bigint "created_by_admin_id"
    t.bigint "updated_by_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_admin_id"], name: "index_resources_created_by_on_admin_user_id"
    t.index ["name"], name: "index_resources_on_name", unique: true
    t.index ["updated_by_admin_id"], name: "index_resources_updated_by_on_admin_user_id"
  end

  create_table "security_roles", force: :cascade do |t|
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_see_welcome_call_dashboard", default: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "slc_model_groups", force: :cascade do |t|
    t.string "model"
    t.integer "model_year"
    t.string "slc_model_group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "make_id"
    t.index ["make_id"], name: "index_slc_model_groups_on_make_id"
  end

  create_table "stipulation_credit_tier_types", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stipulation_credit_tiers", force: :cascade do |t|
    t.bigint "stipulation_credit_tier_type_id"
    t.bigint "stipulation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stipulation_credit_tier_type_id"], name: "index_sctt_on_sitpulation_credit_tier"
    t.index ["stipulation_id"], name: "index_s_on_sitpulation_credit_tier"
  end

  create_table "stipulations", id: :serial, force: :cascade do |t|
    t.string "description"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required", default: false
    t.integer "position"
    t.string "separator", default: "-"
    t.boolean "pre_income_stipulation", default: false
    t.boolean "post_income_stipulation", default: false
    t.boolean "post_submission_stipulation", default: false
    t.boolean "blocks_credit_status_approved", default: false, null: false
    t.boolean "verification_call_problem", default: false
    t.boolean "active", default: true, null: false
  end

  create_table "tax_jurisdiction_types", force: :cascade do |t|
    t.string "name"
    t.integer "sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tax_jurisdictions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "us_state"
    t.integer "state_tax_rule_id"
    t.integer "county_tax_rule_id"
    t.integer "local_tax_rule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geo_code", limit: 9
    t.string "geo_code_state"
    t.string "geo_code_county"
    t.string "geo_code_city"
    t.date "effective_date"
    t.bigint "tax_record_types_id"
    t.string "jurisdiction_name", limit: 100
    t.string "zip_code_start", limit: 10
    t.string "zip_code_end", limit: 10
    t.boolean "ignore_sales_tax_engine", default: false
    t.bigint "us_states_id"
    t.index ["local_tax_rule_id", "county_tax_rule_id", "state_tax_rule_id", "us_state"], name: "index_jurisdiction_on_most_to_least_specific_region"
    t.index ["name", "us_state"], name: "index_tax_jurisdictions_on_name_and_us_state", unique: true
    t.index ["tax_record_types_id"], name: "index_tax_jurisdictions_on_tax_record_types_id"
    t.index ["us_states_id"], name: "index_tax_jurisdictions_on_us_states_id"
  end

  create_table "tax_record_types", force: :cascade do |t|
    t.integer "vertex_record_type", limit: 2
    t.string "record_type_desc", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_rules", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "sales_tax_percentage", precision: 6, scale: 4, default: "0.0"
    t.decimal "up_front_tax_percentage", precision: 6, scale: 4, default: "0.0"
    t.decimal "cash_down_tax_percentage", precision: 6, scale: 4, default: "0.0"
    t.integer "rule_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "effective_date"
    t.decimal "prior_rate"
    t.bigint "tax_jurisdictions_id"
    t.date "end_date", default: "2999-12-31"
    t.string "notes", limit: 100
    t.index ["name"], name: "index_tax_rules_on_name", unique: true
    t.index ["tax_jurisdictions_id"], name: "index_tax_rules_on_tax_jurisdictions_id"
  end

  create_table "us_states", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.boolean "sum_of_payments_state"
    t.boolean "active_on_calculator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "security_deposit", default: 0, null: false
    t.boolean "enable_security_deposit", default: false
    t.string "label_text"
    t.string "hyperlink"
    t.integer "state_enum"
    t.string "geo_code_state", limit: 2
    t.bigint "tax_jurisdiction_type_id"
    t.string "secretary_of_state_website"
    t.boolean "enable_electronic_signatures", default: false, null: false
    t.index ["abbreviation"], name: "index_us_states_on_abbreviation", unique: true
    t.index ["state_enum"], name: "index_us_states_on_state_enum", unique: true
    t.index ["tax_jurisdiction_type_id"], name: "index_us_states_on_tax_jurisdiction_type_id"
  end

  create_table "usio_return_codes", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_inventories", force: :cascade do |t|
    t.string "asset_make"
    t.string "asset_model"
    t.integer "asset_year"
    t.string "asset_vin"
    t.string "asset_color"
    t.string "exact_odometer_mileage"
    t.string "new_used"
    t.string "stock_number"
    t.datetime "intake_date"
    t.datetime "sale_date"
    t.bigint "inventory_status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_status_id"], name: "index_vehicle_inventories_on_inventory_status_id"
  end

  create_table "vehicle_inventory_images", force: :cascade do |t|
    t.string "image"
    t.bigint "vehicle_inventory_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["vehicle_inventory_id"], name: "index_vehicle_inventory_images_on_vehicle_inventory_id"
  end

  create_table "welcome_call_representative_types", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "welcome_call_results", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_index"
  end

  create_table "welcome_call_statuses", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "welcome_call_types", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_index"
  end

  create_table "workflow_setting_values", force: :cascade do |t|
    t.bigint "workflow_setting_id"
    t.bigint "admin_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_workflow_setting_values_on_admin_user_id"
    t.index ["workflow_setting_id"], name: "index_workflow_setting_values_on_workflow_setting_id"
  end

  create_table "workflow_settings", force: :cascade do |t|
    t.string "workflow_setting_name"
    t.bigint "workflow_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["workflow_id"], name: "index_workflow_settings_on_workflow_id"
  end

  create_table "workflow_statuses", force: :cascade do |t|
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflows", force: :cascade do |t|
    t.string "workflow_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "actions", "admin_users", column: "created_by_admin_id"
  add_foreign_key "actions", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "addresses", "cities"
  add_foreign_key "adjusted_capitalized_cost_histories", "adjusted_capitalized_cost_ranges"
  add_foreign_key "adjusted_capitalized_cost_histories", "admin_users"
  add_foreign_key "adjusted_capitalized_cost_ranges", "credit_tiers"
  add_foreign_key "admin_user_security_roles", "admin_users"
  add_foreign_key "admin_user_security_roles", "admin_users", column: "created_by_admin_id"
  add_foreign_key "admin_user_security_roles", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "admin_user_security_roles", "security_roles"
  add_foreign_key "banners", "admin_users", column: "created_by_admin_id"
  add_foreign_key "banners", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "blackbox_model_details", "blackbox_models"
  add_foreign_key "credit_tiers", "model_groups"
  add_foreign_key "dealer_representatives", "admin_users"
  add_foreign_key "dealer_representatives", "dealerships"
  add_foreign_key "dealer_security_roles", "admin_users", column: "created_by_admin_id"
  add_foreign_key "dealer_security_roles", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "dealer_security_roles", "dealers"
  add_foreign_key "dealer_security_roles", "security_roles"
  add_foreign_key "dealership_approval_events", "admin_users"
  add_foreign_key "dealership_approval_events", "dealership_approvals"
  add_foreign_key "dealership_approvals", "dealership_approval_types"
  add_foreign_key "dealership_approvals", "dealerships"
  add_foreign_key "dealership_attachments", "admin_users"
  add_foreign_key "dealership_attachments", "dealerships"
  add_foreign_key "dealerships", "addresses"
  add_foreign_key "dealerships", "addresses", column: "owner_address_id"
  add_foreign_key "dealerships", "remit_to_dealer_calculations"
  add_foreign_key "funding_delays", "funding_delay_reasons"
  add_foreign_key "funding_delays", "lease_applications"
  add_foreign_key "funding_request_histories", "lease_applications"
  add_foreign_key "income_verification_attachments", "income_verifications"
  add_foreign_key "income_verification_attachments", "lease_application_attachments"
  add_foreign_key "income_verifications", "admin_users", column: "created_by_admin_id"
  add_foreign_key "income_verifications", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "insurances", "insurance_companies"
  add_foreign_key "lease_application_attachment_meta_data", "file_attachment_types"
  add_foreign_key "lease_application_attachment_meta_data", "lease_application_attachments"
  add_foreign_key "lease_application_attachment_meta_data", "lease_applications"
  add_foreign_key "lease_application_attachments", "lease_applications"
  add_foreign_key "lease_application_blackbox_errors", "lease_application_blackbox_requests"
  add_foreign_key "lease_application_blackbox_requests", "lessees"
  add_foreign_key "lease_application_blackbox_tlo_person_search_addresses", "lease_application_blackbox_requests"
  add_foreign_key "lease_application_gps_units", "admin_users", column: "created_by_admin_id"
  add_foreign_key "lease_application_gps_units", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "lease_application_gps_units", "lease_applications"
  add_foreign_key "lease_application_payment_limits", "credit_tiers"
  add_foreign_key "lease_application_payment_limits", "lease_applications"
  add_foreign_key "lease_application_recommended_blackbox_tiers", "blackbox_model_details"
  add_foreign_key "lease_application_recommended_blackbox_tiers", "lease_applications"
  add_foreign_key "lease_application_recommended_credit_tiers", "credit_tiers"
  add_foreign_key "lease_application_recommended_credit_tiers", "lease_applications"
  add_foreign_key "lease_application_stipulations", "lease_applications"
  add_foreign_key "lease_application_stipulations", "stipulations"
  add_foreign_key "lease_applications", "cities"
  add_foreign_key "lease_applications", "dealers"
  add_foreign_key "lease_applications", "dealerships"
  add_foreign_key "lease_applications", "departments"
  add_foreign_key "lease_applications", "lease_calculators"
  add_foreign_key "lease_applications", "lessees"
  add_foreign_key "lease_applications", "lessees", column: "colessee_id"
  add_foreign_key "lease_applications", "mail_carriers"
  add_foreign_key "lease_applications", "workflow_statuses"
  add_foreign_key "lease_calculators", "credit_tiers"
  add_foreign_key "lease_calculators", "model_years"
  add_foreign_key "lease_document_requests", "lease_applications"
  add_foreign_key "lease_document_requests", "model_years"
  add_foreign_key "lease_management_systems", "lease_management_system_document_statuses"
  add_foreign_key "lease_validations", "lease_applications"
  add_foreign_key "lessee_recommended_blackbox_tiers", "blackbox_model_details"
  add_foreign_key "lessee_recommended_blackbox_tiers", "lease_application_blackbox_requests"
  add_foreign_key "lessee_recommended_blackbox_tiers", "lessees"
  add_foreign_key "lessees", "lease_applications", column: "deleted_from_lease_application_id"
  add_foreign_key "model_groups", "makes"
  add_foreign_key "negative_pays", "lease_applications"
  add_foreign_key "negative_pays", "lessees"
  add_foreign_key "online_funding_approval_checklists", "lease_applications"
  add_foreign_key "permissions", "actions"
  add_foreign_key "permissions", "admin_users", column: "created_by_admin_id"
  add_foreign_key "permissions", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "permissions", "resources"
  add_foreign_key "permissions", "security_roles"
  add_foreign_key "prenotes", "lease_applications"
  add_foreign_key "references", "lease_applications"
  add_foreign_key "resources", "admin_users", column: "created_by_admin_id"
  add_foreign_key "resources", "admin_users", column: "updated_by_admin_id"
  add_foreign_key "slc_model_groups", "makes"
  add_foreign_key "tax_jurisdictions", "tax_record_types", column: "tax_record_types_id"
  add_foreign_key "tax_jurisdictions", "us_states", column: "us_states_id"
  add_foreign_key "tax_rules", "tax_jurisdictions", column: "tax_jurisdictions_id"
  add_foreign_key "vehicle_inventories", "inventory_statuses"
  add_foreign_key "vehicle_inventory_images", "vehicle_inventories"
  add_foreign_key "workflow_setting_values", "admin_users"
  add_foreign_key "workflow_setting_values", "workflow_settings"
  add_foreign_key "workflow_settings", "workflows"
end
