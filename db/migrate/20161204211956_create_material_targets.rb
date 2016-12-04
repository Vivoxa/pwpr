class CreateMaterialTargets < ActiveRecord::Migration
  def change
    create_table :material_targets do |t|
      t.references :packaging_material, foreign_key: true
      t.references :annual_target_set, foreign_key: true
      t.string :year
      t.float :value

      t.timestamps null: false
    end
  end
end
