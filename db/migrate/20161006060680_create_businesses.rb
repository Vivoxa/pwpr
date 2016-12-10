class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.references :scheme, index: true, foreign_key: true, null: false
      t.string :name
      t.integer :membership_id
      t.string :NPWD
      t.timestamps null: false
    end
  end
end
