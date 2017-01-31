class AddApprovedToCompanyOperators < ActiveRecord::Migration
  def change
    add_column :company_operators, :approved, :boolean, :default => false, :null => false
    add_index  :company_operators, :approved
  end
end
