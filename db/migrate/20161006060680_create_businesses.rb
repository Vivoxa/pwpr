class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :NPWD
      t.references :scheme, index: true, foreign_key: true
      t.references :country_of_business_registration
      t.timestamps null: false
    end
  end
end
