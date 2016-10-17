class AddNameAndSchemeIdToCompanyOperator < ActiveRecord::Migration
  def change
    add_reference :company_operators, :business, index: true, foreign_key: true
    add_column :company_operators, :name, :string
  end
end
