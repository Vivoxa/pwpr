class CreateAddressTypes < ActiveRecord::Migration
  def change
    create_table :address_types do |t|
      t.string :title, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
