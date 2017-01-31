class CreateChangeDetails < ActiveRecord::Migration
  def change
    create_table :change_details do |t|
      t.string :modification, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
