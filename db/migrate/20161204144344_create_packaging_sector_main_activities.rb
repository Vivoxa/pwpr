class CreatePackagingSectorMainActivities < ActiveRecord::Migration
  def change
    create_table :packaging_sector_main_activities do |t|
      t.string :material, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
