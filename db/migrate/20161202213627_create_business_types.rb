class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_type_codes do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
