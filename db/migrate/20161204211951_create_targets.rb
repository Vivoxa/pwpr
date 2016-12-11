class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.references :target_field, foreign_key: true, null: false
      t.references :annual_target_set, foreign_key: true, null: false
      t.string :year, null: false
      t.decimal :value, precision: 5, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
