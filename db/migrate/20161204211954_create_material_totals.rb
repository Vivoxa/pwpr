class CreateMaterialTotals < ActiveRecord::Migration
  def change
    create_table :material_totals do |t|
      t.references :regular_producer_detail, foreign_key: true, null: false
      t.references :packaging_material, foreign_key: true, null: false
      t.decimal :recycling_obligation, null: false

      t.timestamps null: false
    end
  end
end
