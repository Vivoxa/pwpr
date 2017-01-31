class CreatePackagingMaterials < ActiveRecord::Migration
  def change
    create_table :packaging_materials do |t|
      t.string :name, null: false
      t.string :description
      t.string :year_introduced, null: false
      t.boolean :active, default: false, null: false

      t.timestamps null: false
    end
  end
end
