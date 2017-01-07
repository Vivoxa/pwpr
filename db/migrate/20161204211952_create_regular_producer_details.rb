class CreateRegularProducerDetails < ActiveRecord::Migration
  def change
    create_table :regular_producer_details do |t|
      t.references :registration, foreign_key: { on_delete: :cascade }

      t.boolean :calculation_method_supplier_data
      t.boolean :calculation_method_or_other_method_used
      t.boolean :calculation_method_sample_weighing
      t.boolean :calculation_method_sales_records
      t.boolean :calculation_method_trade_association_method_details
      t.boolean :consultant_system_used
      t.string :other_method_details
      t.string :data_system_used

      t.timestamps null: false
    end
  end
end
