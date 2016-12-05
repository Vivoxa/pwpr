class CreateMaterialDetails < ActiveRecord::Migration
  def change
    create_table :material_details do |t|
      t.references :regular_producer_detail, foreign_key: true
      t.references :packaging_material, foreign_key: true

      t.decimal :t1manwo
      t.decimal :t1conv
      t.decimal :t1pf
      t.decimal :t1sell
      t.decimal :t2aman
      t.decimal :t2conv
      t.decimal :t2apf
      t.decimal :t2sell
      t.decimal :t2bman
      t.decimal :t2bconv
      t.decimal :t2bp
      t.decimal :t2bsell
      t.decimal :t3aconv
      t.decimal :t3apf
      t.decimal :t3asell
      t.decimal :t3b
      t.decimal :t3c

      t.timestamps null: false
    end
  end
end
