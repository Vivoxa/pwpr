class CreateMaterialTotals < ActiveRecord::Migration
  def change
    create_table :material_totals do |t|
      t.references :regular_producer_detail, null: false, foreign_key: { on_delete: :cascade }
      t.references :packaging_material, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :recycling_obligation, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
