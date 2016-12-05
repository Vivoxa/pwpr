class AddColumnsToScheme < ActiveRecord::Migration
  def change
    add_column :schemes, :scheme_country_code_id, :integer
  end
end
