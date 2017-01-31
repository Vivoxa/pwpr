class CreateSmallProducerObligations < ActiveRecord::Migration
  def change
    create_table :small_producer_obligations do |t|
      t.decimal :sme, precision: 10, scale: 2
      t.decimal :glass_split, precision: 10, scale: 2
      t.string :year

      t.timestamps null: false
    end
  end
end
