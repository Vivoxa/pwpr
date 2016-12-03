class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :business, foreign_key: true
      t.references :address_type, foreign_key: true
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4
      t.string :post_code
      t.string :county
      t.string :site_country
      t.string :telephone
      t.string :fax
      t.string :email

      t.timestamps null: false
    end
  end
end
