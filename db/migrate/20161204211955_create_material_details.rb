class CreateMaterialDetails < ActiveRecord::Migration
  def change
    create_table :material_details do |t|
      t.references :regular_producer_detail, foreign_key: true
      t.references :packaging_material, foreign_key: true

      t.float :t1manwo
      t.float :t1conv
      t.float :t1pf
      t.float :t1sell
      t.float :t2aman
      t.float :t2conv
      t.float :t2apf
      t.float :t2sell
      t.float :t2bman
      t.float :t2bconv
      t.float :t2bp
      t.float :t2bsell
      t.float :t3aconv
      t.float :t3apf
      t.float :t3asell
      t.float :t3b
      t.float :t3c

      t.timestamps null: false
    end
  end
end
