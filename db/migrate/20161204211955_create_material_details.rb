class CreateMaterialDetails < ActiveRecord::Migration
  def change
    create_table :material_details do |t|
      t.references :regular_producer_detail, null: false, foreign_key: { on_delete: :cascade }
      t.references :packaging_material, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :t1man, precision: 10, scale: 2, null: false
      t.decimal :t1conv, precision: 10, scale: 2, null: false
      t.decimal :t1pf, precision: 10, scale: 2, null: false
      t.decimal :t1sell, precision: 10, scale: 2, null: false
      t.decimal :t2aman, precision: 10, scale: 2, null: false
      t.decimal :t2aconv, precision: 10, scale: 2, null: false
      t.decimal :t2apf, precision: 10, scale: 2, null: false
      t.decimal :t2asell, precision: 10, scale: 2, null: false
      t.decimal :t2bman, precision: 10, scale: 2, null: false
      t.decimal :t2bconv, precision: 10, scale: 2, null: false
      t.decimal :t2bpf, precision: 10, scale: 2, null: false
      t.decimal :t2bsell, precision: 10, scale: 2, null: false
      t.decimal :t3aconv, precision: 10, scale: 2, null: false
      t.decimal :t3apf, precision: 10, scale: 2, null: false
      t.decimal :t3asell, precision: 10, scale: 2, null: false
      t.decimal :t3b, precision: 10, scale: 2, null: false
      t.decimal :t3c, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
