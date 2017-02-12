class FixTableForManualEntryAndRegularProducerImportFields < ActiveRecord::Migration
  def change
    # Add default for licensor
    change_column :registrations, :licensor, :boolean, default: false

    # Ensure columns cannot be null
    change_column :registrations, :agency_template_upload_id, :integer, null: true
    change_column :regular_producer_details, :registration_id, :integer, null: false
    change_column :regular_producer_details, :calculation_method_supplier_data, :boolean, null: false
    change_column :regular_producer_details, :calculation_method_sample_weighing, :boolean, null: false
    change_column :regular_producer_details, :calculation_method_sales_records, :boolean, null: false

    # Change field type
    change_column :regular_producer_details, :calculation_method_trade_association_method_details, :string

    # Remove redundant columns
    remove_column :regular_producer_details, :consultant_system_used
    remove_column :regular_producer_details, :calculation_method_or_other_method_used
  end
end
