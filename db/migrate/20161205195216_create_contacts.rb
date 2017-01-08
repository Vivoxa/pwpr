class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :business, foreign_key: true, null: false
      t.references :address_type, foreign_key: true, null: false
      t.string :title
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :telephone_1, null: false
      t.string :telephone_2
      t.string :fax
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
