class CreateSmallProducerDetails < ActiveRecord::Migration
  def change
    create_table :small_producer_details do |t|
      t.references :registration, foreign_key: true
      t.references :subsidiary, foreign_key: true
      t.string :allocation_method_predominant_material, null: false
      t.integer :allocation_method_obligation, null: false

      t.timestamps null: false
    end
  end
end
