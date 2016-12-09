class CreateMaterialTargets < ActiveRecord::Migration
  def change
    create_table :material_targets do |t|
      t.references :packaging_material, foreign_key: true, null: false
      t.references :annual_target_set, foreign_key: true, null: false
      t.string :year, null: false
      t.decimal :value, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
