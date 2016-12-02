class CreatePackagingSectorActivities < ActiveRecord::Migration
  def change
    create_table :packaging_sector_activities do |t|
      t.string :type, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
