class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :business, foreign_key: true, null: false
      t.references :address_type, foreign_key: true, null: false
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4
      t.string :town
      t.string :post_code, null: false
      t.string :county, null: false
      t.string :site_country, null: false
      t.string :telephone, null: false
      t.string :fax
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
