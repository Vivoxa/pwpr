class CreateBusinessSubtypes < ActiveRecord::Migration
  def change
    create_table :business_subtype_codes do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
