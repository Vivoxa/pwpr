class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
  end
end
