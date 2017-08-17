class ChangeRegularProducerFields < ActiveRecord::Migration
  def change
    remove_column :regular_producer_details, :calculation_method_trade_association_method_details
    remove_column :regular_producer_details, :data_system_used
    add_column :regular_producer_details, :trade_association_method_id, :integer
    add_column :regular_producer_details, :data_system_id, :integer
  end
end
