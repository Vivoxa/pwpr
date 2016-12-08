class CreateMaterialDetails < ActiveRecord::Migration
  def change
    create_table :material_details do |t|
      t.references :regular_producer_detail, foreign_key: true, null: false
      t.references :packaging_material, foreign_key: true, null: false

      t.decimal :t1manwo, null: false
      t.decimal :t1conv, null: false
      t.decimal :t1pf, null: false
      t.decimal :t1sell, null: false
      t.decimal :t2aman, null: false
      t.decimal :t2conv, null: false
      t.decimal :t2apf, null: false
      t.decimal :t2sell, null: false
      t.decimal :t2bman, null: false
      t.decimal :t2bconv, null: false
      t.decimal :t2bp, null: false
      t.decimal :t2bsell, null: false
      t.decimal :t3aconv, null: false
      t.decimal :t3apf, null: false
      t.decimal :t3asell, null: false
      t.decimal :t3b, null: false
      t.decimal :t3c, null: false

      t.timestamps null: false
    end
  end
end
