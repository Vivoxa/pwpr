class CreateMaterialTotals < ActiveRecord::Migration
  def change
    create_table :material_totals do |t|
      t.references :regular_producer_detail, foreign_key: true
      t.references :packaging_material, foreign_key: true
      t.decimal :recycling_obligation, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
