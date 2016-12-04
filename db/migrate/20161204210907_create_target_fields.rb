class CreateTargetFields < ActiveRecord::Migration
  def change
    create_table :target_fields do |t|
      t.string :name
      t.string :description
      t.string :year_introduced
      t.boolean :active

      t.timestamps null: false
    end
  end
end
