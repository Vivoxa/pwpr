class AddNameToScheme < ActiveRecord::Migration
  def change
    add_column :schemes, :name, :string
  end
end
