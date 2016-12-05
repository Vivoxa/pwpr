class CreateContactsAddresses < ActiveRecord::Migration
  def change
    create_table :contacts_addresses do |t|
      t.references :address, foreign_key: true
      t.references :contact, foreign_key: true

      t.timestamps null: false
    end
  end
end
