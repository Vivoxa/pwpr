class AddColumnsToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :membership_number, :string
    add_column :businesses, :trading_name, :string
    add_column :businesses, :company_number, :string
    add_column :businesses, :business_type_id, :integer
    add_column :businesses, :business_subtype_id, :integer
    add_column :businesses, :sic_code_id, :integer
    add_column :businesses, :country_of_regitration, :string
    add_column :businesses, :year_first_reg, :string
    add_column :businesses, :year_last_reg, :string
    add_column :businesses, :scheme_status_code_id, :integer
    add_column :businesses, :registration_status_code_id, :integer
  end
end
