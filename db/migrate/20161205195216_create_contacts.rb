class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :business, foreign_key: true, null: false
      t.string :title, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :telephone_1, null: false
      t.string :telephone_2
      t.string :fax
      t.boolean :active

      t.timestamps null: false
    end
  end
end
