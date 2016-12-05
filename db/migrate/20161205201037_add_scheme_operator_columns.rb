class AddSchemeOperatorColumns < ActiveRecord::Migration
  def change
    add_column :scheme_operators, :first_name, :string
    add_column :scheme_operators, :last_name, :string
    add_column :scheme_operators, :telephone, :string
    add_column :scheme_operators, :fax, :string
    add_column :scheme_operators, :active, :boolean
  end
end
