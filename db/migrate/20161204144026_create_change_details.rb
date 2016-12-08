class CreateChangeDetails < ActiveRecord::Migration
  def change
    create_table :change_details do |t|
      t.string :modification
      t.string :description

      t.timestamps null: false
    end
  end
end
