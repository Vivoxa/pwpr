class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.references :scheme, index: true, foreign_key: true, null: false
      t.integer :membership_id
      t.string :NPWD
      t.string :name
      t.boolean :small_producer
      t.references :country_of_business_registration
      t.timestamps null: false
    end
  end
end
