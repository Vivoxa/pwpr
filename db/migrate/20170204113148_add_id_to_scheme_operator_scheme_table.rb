class AddIdToSchemeOperatorSchemeTable < ActiveRecord::Migration
  def change
    add_column :scheme_operators_schemes, :id, :primary_key
    change_column :scheme_operators_schemes, :scheme_id, :integer
    change_column :scheme_operators_schemes, :scheme_operator_id, :integer
  end
end