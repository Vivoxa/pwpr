class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :business, foreign_key: true
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :telephone_1
      t.string :telephone_2
      t.string :fax
      t.boolean :active

      t.timestamps null: false
    end
  end
end
