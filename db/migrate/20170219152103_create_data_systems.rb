class CreateDataSystems < ActiveRecord::Migration
  def change
    create_table :data_systems do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
