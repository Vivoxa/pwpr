class AddColumnsToCompanyOperator < ActiveRecord::Migration
  def change
    add_column :company_operators, :first_name, :string
    add_column :company_operators, :last_name, :string
    add_column :company_operators, :telephone, :string
    add_column :company_operators, :fax, :string
    add_column :company_operators, :active, :boolean
  end
end
