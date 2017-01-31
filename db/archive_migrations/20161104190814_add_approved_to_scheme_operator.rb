class AddApprovedToSchemeOperator < ActiveRecord::Migration
  def change
    add_column :scheme_operators, :approved, :boolean, :default => false, :null => false
    add_index  :scheme_operators, :approved
  end
end
