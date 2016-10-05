class AddNameToSchemeOperator < ActiveRecord::Migration
  def change
    add_column :scheme_operators, :name, :string
  end
end
