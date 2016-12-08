class AddColumnsToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :scheme_ref, :string, null: false
    add_column :businesses, :trading_name, :string, null: false
    add_column :businesses, :company_number, :string, null: false
    add_column :businesses, :business_type_id, :integer
    add_column :businesses, :business_subtype_id, :integer
    add_column :businesses, :sic_code_id, :integer, null: false
    add_column :businesses, :country_of_regitration, :string, null: false
    add_column :businesses, :year_first_reg, :string, null: false
    add_column :businesses, :year_last_reg, :string
    add_column :businesses, :scheme_status_code_id, :integer, null: false
    add_column :businesses, :registration_status_code_id, :integer, null: false
    remove_column :businesses, :SIC
  end
end
