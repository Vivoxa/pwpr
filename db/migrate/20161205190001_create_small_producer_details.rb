class CreateSmallProducerDetails < ActiveRecord::Migration
  def change
    create_table :small_producer_details do |t|
      t.references :registration, foreign_key: true
      t.string :allocation_method_predominant_material
      t.string :allocation_method_obligation

      t.timestamps null: false
    end
  end
end
